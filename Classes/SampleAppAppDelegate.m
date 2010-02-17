//
//  SampleAppAppDelegate.m
//  SampleApp
//
//  Created by Chris Purcell on 2/14/10.
//  Copyright  2010. All rights reserved.
//

#import "SampleAppAppDelegate.h"
#import "SampleAppViewController.h"

@implementation SampleAppAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
