//
//  S3ItemViewer.m
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/16/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import "S3ItemViewer.h"

@interface S3ItemViewer ()

@end

@implementation S3ItemViewer

@synthesize imageItem;

@synthesize webS3Viewer;
@synthesize delegate;
@synthesize urlItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
      return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.urlItem];
    [webS3Viewer loadRequest:request];
    

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidUnload
{
    
    [self setWebS3Viewer:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)buttonDone:(id)sender {
    [self.delegate s3ItemViewerDidDone:self];
}
@end
