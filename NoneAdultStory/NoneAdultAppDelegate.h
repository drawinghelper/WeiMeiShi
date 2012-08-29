//
//  NoneAdultAppDelegate.h
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MobClick.h"
#import "UMFeedback.h"
#import "Appirater.h"
#import <Parse/Parse.h>
#import "FMDatabase.h"


typedef enum {
    UIActionShare  = 0,
    UIActionCollect  = 1,
    UIActionView  = 2,
} UIAction;

typedef enum {
    UIChannelNew  = 0,
    UIChannelMagzine  = 1,
    UIChannelHistory  = 2,
} UIChannel;

@interface NoneAdultAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
+ (CGColorRef) getColorFromRed:(int)red Green:(int)green Blue:(int)blue Alpha:(int)alpha;
-(NSString *)getDbPath;
+ (NoneAdultAppDelegate *)sharedAppDelegate;
- (NSString *)getMogoAppKey;
- (NSString *)getUmengAppKey;
- (NSString *)getAppStoreId;
- (NSString *)getAppChannelTag;
- (BOOL)isInReview;
- (BOOL)isAdmin;
- (void)scoreForShareUrl:(NSDictionary *)currentDuanZi action:(UIAction)action;
@end
