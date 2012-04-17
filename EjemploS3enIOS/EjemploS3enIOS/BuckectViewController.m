//
//  BuckectViewController.m
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/13/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import "BuckectViewController.h"

@interface BuckectViewController ()

@end

@implementation BuckectViewController
@synthesize nameBucketTextField;
@synthesize delegate;

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
    [self setNameBucketTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     
     */
    
    if (indexPath.section == 0) {
        [self.nameBucketTextField becomeFirstResponder];
    }
    
}

-(IBAction)cancel:(id)sender{
    [self.delegate buckectViewControllerDidCancel:self];
}

- (IBAction)done:(id)sender{
    
    [self.delegate buckectViewController:self bucketName:self.nameBucketTextField.text];
}



@end
