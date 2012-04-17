//
//  BuckectViewController.h
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/13/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BuckectViewController;

@protocol BuckectViewControllerDelegate  <NSObject>

- (void)buckectViewControllerDidCancel:(BuckectViewController*) controller;
//- (void)buckectViewControllerDidSave:(BuckectViewController*) controller;
- (void)buckectViewController:(BuckectViewController*) controller bucketName:(NSString*)theBucketName;
@end

@interface BuckectViewController : UITableViewController 


@property (nonatomic, weak) id <BuckectViewControllerDelegate> delegate;
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameBucketTextField;

@end
