//
//  NoneAdultAppDelegate.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultAppDelegate.h"

#import "NoneAdultFirstViewController.h"

#import "NoneAdultSecondViewController.h"
#import "NoneAdultMonthTopViewController.h"
#import "NoneAdultWeekTopViewController.h"

@implementation NoneAdultAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

+(CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha
{
    CGFloat r = (CGFloat) red/255.0;
    CGFloat g = (CGFloat) green/255.0;
    CGFloat b = (CGFloat) blue/255.0;
    CGFloat a = (CGFloat) alpha/255.0;  
    CGFloat components[4] = {r,g,b,a};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
	CGColorRef color = (CGColorRef)CGColorCreate(colorSpace, components);
    CGColorSpaceRelease(colorSpace);
	
    return color;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MobClick startWithAppkey:@"4fa3232652701556cc00001e" reportPolicy:REALTIME channelId:nil];
    [MobClick checkUpdate];
    [MobClick updateOnlineConfig];
    
    [Socialize storeConsumerKey:@"dd52d1dc-170e-49e5-bb5c-7d5ecc6fe879"];
    [Socialize storeConsumerSecret:@"a9ba6011-96e8-4c5f-be41-c2e1d37e1cb6"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *newController = [[NoneAdultFirstViewController alloc] initWithNibName:@"NoneAdultFirstViewController" bundle:nil];
    UINavigationController *newNavViewController = [[UINavigationController alloc] initWithRootViewController:newController];
    [newNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    UIViewController *historyTopController = [[NoneAdultSecondViewController alloc] initWithNibName:@"NoneAdultSecondViewController" bundle:nil];
    UINavigationController *historyTopNavViewController = [[UINavigationController alloc] initWithRootViewController:historyTopController];
    [historyTopNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
   
    UIViewController *monthTopController = [[NoneAdultMonthTopViewController alloc] initWithNibName:@"NoneAdultMonthTopViewController" bundle:nil];
    UINavigationController *monthTopNavViewController = [[UINavigationController alloc] initWithRootViewController:monthTopController];
    [monthTopNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    UIViewController *weekTopController = [[NoneAdultWeekTopViewController alloc] initWithNibName:@"NoneAdultWeekTopViewController" bundle:nil];
    UINavigationController *weekTopNavViewController = [[UINavigationController alloc] initWithRootViewController:weekTopController];
    [weekTopNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             newNavViewController, 
                                             historyTopNavViewController,
                                             monthTopNavViewController,
                                             weekTopNavViewController,
                                             nil];
    self.window.rootViewController = self.tabBarController;
    [NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
