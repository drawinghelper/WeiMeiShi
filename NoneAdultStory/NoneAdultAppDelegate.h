//
//  NoneAdultAppDelegate.h
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Socialize/Socialize.h>
#import "MobClick.h"
#import "UMFeedback.h"
#import "UAirship.h"
#import "Appirater.h"
#import <Parse/Parse.h>

@interface NoneAdultAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    NSString *configContentsource;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *configContentsource;

@property (strong, nonatomic) UITabBarController *tabBarController;
+ (CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha;
+ (NoneAdultAppDelegate *)sharedAppDelegate;
- (NSString *)getConfigContentsource;
@end
