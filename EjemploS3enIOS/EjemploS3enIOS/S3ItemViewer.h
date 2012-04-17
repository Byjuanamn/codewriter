//
//  S3ItemViewer.h
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 4/16/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class S3ItemViewer;

@protocol S3ItemViewerDelegate <NSObject>

- (void)s3ItemViewerDidDone:(S3ItemViewer *)controller; 

@end

@interface S3ItemViewer : UIViewController 

@property (strong, nonatomic) IBOutlet UIWebView *webS3Viewer;
@property (nonatomic, weak) id <S3ItemViewerDelegate> delegate;
@property (nonatomic, weak) UIImage *imageItem;

@property (nonatomic, weak) NSURL *urlItem;

- (IBAction)buttonDone:(id)sender;

@end
