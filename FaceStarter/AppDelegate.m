//
//  AppDelegate.m
//  ME
//
//  Created by Jack Rogers on 5/4/16.
//  Copyright © 2016 Jack Rogers. All rights reserved.
//

#import "AppDelegate.h"
#import "FaceStarter-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[MainViewController alloc] init];
  return YES;
}

@end
