//
//  S3ObjectsViewController.h
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/16/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "S3Item.h"
#import "S3ItemViewer.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import "KeyS3.h"


@class S3ObjectsViewController;

@protocol S3ObjectsViewControllerDelegate <NSObject>

- (void)s3ObjectsViewControllerDidDone:(S3ObjectsViewController*) controller;
- (void)s3ObjectsViewControllerDidAddObject:(S3ObjectsViewController *)controller;

@end

@interface S3ObjectsViewController : UITableViewController <S3ItemViewerDelegate, UIImagePickerControllerDelegate, AmazonServiceRequestDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *theImagePicker;
}

@property (nonatomic, strong) UIImagePickerController *pickerController;
@property (nonatomic, strong) NSMutableArray *objectsInBuckect;
@property (nonatomic, weak) NSString *bucketName;

@property (nonatomic, weak) id <S3ObjectsViewControllerDelegate> delegate;
- (IBAction)addButton:(id)sender;
- (IBAction)doneButton:(id)sender;


@end
