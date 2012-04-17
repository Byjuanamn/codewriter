//
//  S3ObjectsViewController.m
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/16/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import "S3ObjectsViewController.h"

@interface S3ObjectsViewController ()

@end

@implementation S3ObjectsViewController
@synthesize delegate;
@synthesize objectsInBuckect;
@synthesize bucketName;
@synthesize pickerController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
       
   return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.pickerController = [[UIImagePickerController alloc]init];
    self.objectsInBuckect = (NSMutableArray *) [self getAllItemsInCurrentBucket];
    [self.tableView reloadData];
    
}



- (void)viewDidUnload
{    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [objectsInBuckect count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ObjectsBucket";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    S3Item *theItem = [self.objectsInBuckect objectAtIndex:indexPath.row];

    cell.textLabel.text = theItem.nombre;
    cell.detailTextLabel.text = [theItem.urlS3Foto absoluteString];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}


- (IBAction)addButton:(id)sender {
    
    theImagePicker = [[UIImagePickerController alloc]init];
    theImagePicker.delegate = self;
    [self presentModalViewController:theImagePicker animated:YES];
    
  //  [self.delegate s3ObjectsViewControllerDidAddObject:self];
}

- (IBAction)doneButton:(id)sender {
    [self.delegate s3ObjectsViewControllerDidDone:self];
}

#pragma mark - ImagePicker methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *dataS3Object = UIImageJPEGRepresentation(image, 0.2);

    //nombre del fichero de la imagen
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsInDirectory = [paths objectAtIndex:0];
 //   NSError *error = nil;
 //   NSArray *dirContents = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:documentsInDirectory error:&error];
   
    //marcamos la diferecia del nombre con la fecha
    NSDate *currentTime =[NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"MMyyddhhmma"];    
    NSString *filename = [NSString stringWithFormat:@"thePhoto%@.jpeg", [timeFormatter stringFromDate:currentTime]];
    NSString *imagePath = [documentsInDirectory stringByAppendingPathComponent:filename];
    
    //guardamos la imagen en el Documents Directory
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        [dataS3Object writeToFile:imagePath atomically:YES];
    }
    
    
    S3PutObjectRequest *s3putObject = [[S3PutObjectRequest alloc]initWithKey:filename inBucket:bucketName];

    s3putObject.bucket = bucketName;
    s3putObject.contentType = @"image/jpeg";
    s3putObject.filename = imagePath;
    s3putObject.delegate = self;
    
    // instancia de cliente AmazonS3 para hacer el put del objeto
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];
    
    [s3Client putObject:s3putObject];
   
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}
/////////////
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"viewS3Object"]) {
        NSLog(@"a cargar la foto");
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        NSURL *theUrl = [NSURL URLWithString:cell.detailTextLabel.text];
        
        UINavigationController *navigatioController = segue.destinationViewController;
        S3ItemViewer *itemViewer = [[navigatioController viewControllers]objectAtIndex:0];
        itemViewer.urlItem = theUrl;
        itemViewer.delegate = self;
    } 
}



#pragma mark - S3ItemViewerDelegates methods

-(void)s3ItemViewerDidDone:(S3ItemViewer *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AmazonServiceREquestDelegate Methods

- (void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response{
    
    NSLog(@"Resultado %@",response);
    if (response.httpStatusCode == 200) {
        
        NSArray *items= [self getAllItemsInCurrentBucket];
        if (self.objectsInBuckect == nil) {
            self.objectsInBuckect = [[NSMutableArray alloc]initWithCapacity:[items count]];
        } else {
            [self.objectsInBuckect removeAllObjects];
        }
        self.objectsInBuckect = (NSMutableArray *) items;
        [self.tableView reloadData];
    }
}

#pragma mark - S3 mehotds

- (NSArray*)getAllItemsInCurrentBucket{
    
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];
    
    
    //rellenamos un array con la info de los objetos del bucket actual
    
    NSArray *itemsInBucket = [s3Client listObjectsInBucket:self.bucketName];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]initWithCapacity:[itemsInBucket count]];
    
    // rellenamos el array de objetos, obteniendo su Url para ser mostrado
    
    
    for (int i=0; i<[itemsInBucket count]; i++) {
        
        S3Item *theItem = [[S3Item alloc]init];
        
        S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
        override.contentType = @"image/jpeg";
        
        S3GetPreSignedURLRequest *gpurl = [[S3GetPreSignedURLRequest alloc] init];
        
        gpurl.key = [[itemsInBucket objectAtIndex:i]valueForKey:@"key"]; 
        gpurl.bucket = bucketName;
        gpurl.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval)3600];
        gpurl.responseHeaderOverrides = override;
        
        theItem.nombre = gpurl.key;
        theItem.buckectNombre = gpurl.bucket;
        
        [theItem setUrlS3Foto:[s3Client getPreSignedURL:gpurl]];
        
        [itemsArray addObject:theItem];
        
    }
    return ((NSArray *) itemsArray);
    

    
}

@end
