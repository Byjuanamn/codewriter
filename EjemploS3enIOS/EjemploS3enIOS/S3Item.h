//
//  FotosS3.h
//  S3PocImageViewer
//
//  Created by Juan Antonio Martin on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S3Item : NSObject

@property (nonatomic, retain) NSString *nombre;
@property (nonatomic, retain) NSString *buckectNombre;
@property (nonatomic, retain) NSURL *urlS3Foto;

@end
