//
//  ITAppDelegate.m
//  Example
//
//  Created by Nguyen Anh Tuan on 26/08/2013.
//  Copyright (c) 2013 tuanit09@gmail.com. All rights reserved.
//

#import "ITAppDelegate.h"
#import "ITDictionary.h"

@implementation ITAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    NSString *infoFile = [[NSBundle mainBundle] pathForResource:@"en_vi" ofType:@"ifo"];
    NSString *indexFile = [[NSBundle mainBundle] pathForResource:@"en_vi" ofType:@"idx"];
    NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"en_vi.dict" ofType:@"dz"];
    ITDictionary *dictionary = [[ITDictionary alloc] initWithInfoFile:infoFile indexFile:indexFile dataFile:dataFile synFile:@"abc"];
    [dictionary loadDictionary];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
