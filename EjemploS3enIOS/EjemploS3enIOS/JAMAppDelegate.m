//
//  JAMAppDelegate.m
//  EjemploS3enIOS
//
//  Created by Juan Antonio Martin on 3/26/12.
//  Copyright (c) 2012 freelance. All rights reserved.
//

#import "JAMAppDelegate.h"
#import "KeyS3.h"
#import <AWSiOSSDK/S3/AmazonS3Client.h>

#import "S3ViewController.h"

@implementation JAMAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // comprobamos el acceso 
    // este trozo de codigo en este punto es totalmente superfluo, esto es una prueba de concepto
   
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kACCESS_KEY 
                                                           withSecretKey:kSECRET_KEY];
    NSArray *listaBuckets;
    @try {  
        listaBuckets = [s3Client listBuckets];
        
        
        for (S3Bucket *bucket in listaBuckets) {
            NSLog(@"Buckets : %@",bucket.name);
        }
        

    }
    @catch (AmazonClientException *exception) {
        NSLog(@"%@",exception.description);
    }
    
    

    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;
    
    S3ViewController *s3ViewController = [[navigationController viewControllers] objectAtIndex:0];
   
    s3ViewController.arrayBuckets = [[NSMutableArray alloc]initWithCapacity:[listaBuckets count]];
    for (S3Bucket *bu in listaBuckets) {
        [s3ViewController.arrayBuckets addObject:bu];
    }
    
    //s3ViewController.arrayBuckets =(NSMutableArray*) listaBuckets;
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
