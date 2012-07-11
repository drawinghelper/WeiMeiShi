//
//  NoneAdultAppDelegate.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultAppDelegate.h"

#import "NoneAdultFirstViewController.h"
#import "MyTableController.h"

#import "NoneAdultSecondViewController.h"
#import "NoneAdultSettingViewController.h"

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
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Updates the device token and registers the token with UA
}

+ (NoneAdultAppDelegate *)sharedAppDelegate
{
    return (NoneAdultAppDelegate *) [UIApplication sharedApplication].delegate;
}

-(NSString *)getDbPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    NSString *documentDirectory = [paths objectAtIndex:0];  
    //dbPath： 数据库路径，在Document中。  
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"NeiHanStoryTencent.db"];  
    NSLog(@"dbPath: %@", dbPath);
    return dbPath;
}

- (void)createCollectTable {
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    }
    
    //[db executeUpdate:@"DROP TABLE collected"];

    //创建一个名为User的表，有两个字段分别为string类型的Name，integer类型的 Age
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS collected (";
	createSQL = [createSQL stringByAppendingString:@" ID INTEGER PRIMARY KEY AUTOINCREMENT,"];

    createSQL = [createSQL stringByAppendingString:@" weiboId INTEGER UNIQUE,"];//微博的id
	createSQL = [createSQL stringByAppendingString:@" profile_image_url TEXT,"];//博主头像图片地址
    createSQL = [createSQL stringByAppendingString:@" screen_name TEXT,"];//微博名
    createSQL = [createSQL stringByAppendingString:@" timestamp INTEGER,"];//微博发表时间
    
	createSQL = [createSQL stringByAppendingString:@" content TEXT,"];//文字内容
    createSQL = [createSQL stringByAppendingString:@" imageurl TEXT,"];//图片内容
    createSQL = [createSQL stringByAppendingString:@" width INTEGER,"];//图片宽度
    createSQL = [createSQL stringByAppendingString:@" height INTEGER,"];//图片高度
    createSQL = [createSQL stringByAppendingString:@" gif INTEGER,"];//图片是否为gif，0为不是gif，1是gif

    createSQL = [createSQL stringByAppendingString:@" favorite_count INTEGER,"];
    createSQL = [createSQL stringByAppendingString:@" bury_count INTEGER,"];//
    createSQL = [createSQL stringByAppendingString:@" comments_count INTEGER,"];//
    
    createSQL = [createSQL stringByAppendingString:@" collect_time INTEGER"];
    createSQL = [createSQL stringByAppendingString:@");"];

    [db executeUpdate:createSQL];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"wqZfQJvWNjK0zQY7U4G388xJIi4c2C8bOgJXx9Q6"
                  clientKey:@"n8FYn4lelC9FNyshKu1D8hmngdJSYJzKn0H1ZanK"];
    
    // Register for notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    [MobClick startWithAppkey:@"4fa3232652701556cc00001e" reportPolicy:REALTIME channelId:nil];
    [MobClick checkUpdate];
    [MobClick updateOnlineConfig];
    
    [self createCollectTable];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *newController = [[NoneAdultFirstViewController alloc] initWithNibName:@"NoneAdultFirstViewController" bundle:nil];
    UINavigationController *newNavViewController = [[UINavigationController alloc] initWithRootViewController:newController];
    [newNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    MyTableController *controller = [[MyTableController alloc] init];
    UIViewController *historyTopController = [[NoneAdultSecondViewController alloc] initWithNibName:@"NoneAdultSecondViewController" bundle:nil];
    UINavigationController *historyTopNavViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [historyTopNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    UIViewController *secondViewController = [[NoneAdultSecondViewController alloc] initWithNibName:@"NoneAdultSecondViewController" bundle:nil];
    UINavigationController *secondNavViewController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [secondNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];

    UIViewController *settingViewController = [[NoneAdultSettingViewController alloc] initWithNibName:@"NoneAdultSettingViewController" bundle:nil];
    UINavigationController *settingNavViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [settingNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             newNavViewController, 
                                             historyTopNavViewController,
                                             secondNavViewController,
                                             settingNavViewController,
                                             nil];
    self.window.rootViewController = self.tabBarController;
    //[NSThread sleepForTimeInterval:2.0];
    [self.window makeKeyAndVisible];
    [Appirater appLaunched:YES];
    
    application.applicationIconBadgeNumber = 0;
    [self buryRoutineNotification];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //这里，你就可以通过notification的useinfo，干一些你想做的事情了
    application.applicationIconBadgeNumber -= 1;
    
    [self buryRoutineNotification];
}

- (void)buryRoutineNotification {
    //删除所有本地应用外推送
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //设置明天的这个时候推送
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    //NSDate *date = [NSDate dateWithTimeIntervalSinceNow:30];
    //创建一个本地推送
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        //设置推送时间
        noti.fireDate = date;
        //设置重复间隔
        noti.repeatInterval = NSWeekCalendarUnit;
        NSString *localNotiRepeatInterval = [MobClick getConfigParams:@"localNotiRepeatInterval"];
        if (localNotiRepeatInterval != nil 
            && localNotiRepeatInterval != [NSNull null] 
            && ![localNotiRepeatInterval isEqualToString:@""]) {
            
            if ([localNotiRepeatInterval isEqualToString:@"week"]) {
                noti.repeatInterval = NSWeekCalendarUnit;
            } else if ([localNotiRepeatInterval isEqualToString:@"day"]) {
                noti.repeatInterval = NSDayCalendarUnit;
            } else {
                noti.repeatInterval = 0;                
            }
        }
        
        //内容
        noti.alertBody = @"今天又有新笑话啦，来看看吧！";
        NSString *localNotiAlertBody = [MobClick getConfigParams:@"localNotiAlertBody"];
        if (localNotiAlertBody != nil 
            && localNotiAlertBody != [NSNull null] 
            && ![localNotiAlertBody isEqualToString:@""]) {
            noti.alertBody = localNotiAlertBody;
        }
        
        //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;
        //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber = 1;
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        noti.userInfo = infoDic;
        //添加推送到uiapplication        
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];  
    }
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
    [Appirater appEnteredForeground:YES];
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
