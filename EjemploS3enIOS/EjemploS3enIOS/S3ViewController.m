//
//  S3ViewController.m
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 3/27/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import "S3ViewController.h"

@interface S3ViewController ()

@end

@implementation S3ViewController

@synthesize arrayBuckets = _arrayBuckets;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    NSLog(@"elementos %d",[_arrayBuckets count]);
    return [self.arrayBuckets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"buckectObjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Mostraremos el nombre del buckect y la fecha de crecion
    cell.textLabel.text = [[self.arrayBuckets objectAtIndex:indexPath.row]valueForKey:@"name"] ;
    cell.detailTextLabel.text = [[self.arrayBuckets objectAtIndex:indexPath.row]valueForKey:@"creationDate"];
    
    return cell;
}


/////////////////////////////////////////////////////////////////


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"AddBucket"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        BuckectViewController *bucketView = [[navigationController viewControllers]objectAtIndex:0];
        bucketView.delegate = self;
    } else {
        if ([segue.identifier isEqualToString:@"BucketDetails"]) {
            NSLog(@"Detalle de bucket");
            UINavigationController *navigationController = segue.destinationViewController;
            S3ObjectsViewController *s3Items = [[navigationController viewControllers]objectAtIndex:0];

            UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
           // s3Items.objectsInBuckect = (NSMutableArray *) [self getItemsFromBucket:cell.textLabel.text];
            s3Items.bucketName = cell.textLabel.text;

            s3Items.delegate = self;            
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.

  }

#pragma mark - buckectViewControllerDelegate

- (void)buckectViewControllerDidCancel:(BuckectViewController*) controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)buckectViewController:(BuckectViewController*) controller bucketName:(NSString *)theBucketName{

    [self createMyBucket:theBucketName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - S3ObjectsViewControllerDelegate methods

-(void)s3ObjectsViewControllerDidDone:(S3ObjectsViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)s3ObjectsViewControllerDidAddObject:(S3ObjectsViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Amazon S3 Methods

- (void)createMyBucket:(NSString*)theBucketName{
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];
        
    @try {  
        
        [s3Client createBucket:[[S3CreateBucketRequest alloc]initWithName:theBucketName andRegion:[S3Region EUIreland]]];  
    }
    @catch (AmazonClientException *exception) {
        NSLog(@"%@",exception);
        
    }
    [self getMyBuckets];
    [self.tableView reloadData];
    
}

- (NSArray*)getItemsFromBucket:(NSString*)bucketName{
// este metodo nos carga los buckets
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];

       
    //rellenamos un array con la info de los objetos del bucket actual
   
    NSArray *itemsInBucket = [s3Client listObjectsInBucket:bucketName];
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
    
//    
//    NSDictionary *bu = [[NSDictionary alloc]initWithObjectsAndKeys:currentBucket, @"BucketName",elementosEnBuckect, @"ItemsInBucket", nil];
//    
//    
//    [fotillos insertObject:bu atIndex:x];
//    */
    return ((NSArray *) itemsArray);
    
}

- (void)getMyBuckets{
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];
    
    
    @try {
        
        NSArray *listaBuckets = (NSMutableArray *)[s3Client listBuckets];
        
        if (_arrayBuckets == nil) {
            self.arrayBuckets = [[NSMutableArray alloc]initWithCapacity:[listaBuckets count]];
        } else {
            [self.arrayBuckets removeAllObjects];
        }
        
        for (S3Bucket *buckect in listaBuckets) {
            [self.arrayBuckets addObject:buckect];
        }
        
    }
    @catch (AmazonClientException *exception) {
        NSLog(@"%@",exception);
        
    }
    
    
    
}

@end
