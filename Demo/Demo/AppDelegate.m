//
//  AppDelegate.m
//  Demo
//
//  Created by qfu on 4/15/16.
//  Copyright © 2016 qfu. All rights reserved.
//

#import "AppDelegate.h"
#import "ShowPlayerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ShowPlayerViewController *controller1 = [[ShowPlayerViewController alloc]init];
    controller1.view.backgroundColor = [UIColor whiteColor];
    controller1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    
    self.tabBarController.viewControllers=@[controller1,];
    
    [self.window setRootViewController:self.tabBarController];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma mark - get & set

- (UIWindow *)window
{
    if (_window == nil) {
        _window = [[UIWindow alloc] init];
    }
    return _window;
}

- (UITabBarController *)tabBarController
{
    if (_tabBarController == nil) {
        _tabBarController = [[UITabBarController alloc] init];
    }
    return _tabBarController;
}

@end
