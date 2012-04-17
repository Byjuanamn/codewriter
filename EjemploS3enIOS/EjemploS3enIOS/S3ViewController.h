//
//  S3ViewController.h
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 3/27/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "KeyS3.h"
#import "BuckectViewController.h"
#import "S3ObjectsViewController.h"
#import "S3Item.h"
#import "KeyS3.h"

@interface S3ViewController : UITableViewController <BuckectViewControllerDelegate, S3ObjectsViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *arrayBuckets;

@end
