//
//  NoneAdultAppDelegate.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultAppDelegate.h"
#import "NewPathViewController.h"
#import "NewCommonViewController.h"
#import "HistoryPathViewController.h"
#import "SearchViewController.h"
#import "ChannelViewController.h"
#import "CollectedViewController.h"
#import "NoneAdultSettingViewController.h"
#import "CMTabBarController.h"

@implementation NoneAdultAppDelegate

@synthesize window = _window;
//@synthesize tabBarController = _tabBarController;

- (BOOL)isNeedShowImage {
    BOOL retVal = [[NoneAdultAppDelegate sharedAppDelegate] getShowImageDefault];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *needShowImageNum = [defaults objectForKey:@"needShowImage"];
    if (needShowImageNum == nil) {
        [defaults setObject:[NSNumber numberWithBool:retVal] forKey:@"needShowImage"];
        [defaults synchronize];
    } else {
        retVal = [needShowImageNum boolValue];
    }
    return retVal;
}
- (void)setNeedShowImage:(BOOL)needShowImage {    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:needShowImage] forKey:@"needShowImage"];
    [defaults synchronize];
}

- (void) animateSplashScreen
{
    
    //fade time
    CFTimeInterval animation_duration = 2.0;
    
    //SplashScreen 
    UIImageView * splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [self.window addSubview:splashView];
    [self.window bringSubviewToFront:splashView];
    
    //Animation (fade away with zoom effect)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animation_duration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:splashView]; 
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -60, 440, 600);
    
    [UIView commitAnimations];
    
}

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
- (void)application:(UIApplication *)application 
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken]; // Send parse the device token
    // Subscribe this user to the broadcast channel, "" 
    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Successfully subscribed to the broadcast channel.");
        } else {
            NSLog(@"Failed to subscribe to the broadcast channel.");
        }
    }];
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

- (void)createDingTable {
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    }
    
    //[db executeUpdate:@"DROP TABLE collected"];
    
    //创建一个名为User的表，有两个字段分别为string类型的Name，integer类型的 Age
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS ding (";
	createSQL = [createSQL stringByAppendingString:@" ID INTEGER PRIMARY KEY AUTOINCREMENT,"];
    
    createSQL = [createSQL stringByAppendingString:@" weiboId INTEGER UNIQUE,"];//微博的id
	createSQL = [createSQL stringByAppendingString:@" profile_image_url TEXT,"];//博主头像图片地址
    createSQL = [createSQL stringByAppendingString:@" screen_name TEXT,"];//微博名
    createSQL = [createSQL stringByAppendingString:@" timestamp INTEGER,"];//微博发表时间
    
	createSQL = [createSQL stringByAppendingString:@" content TEXT,"];//文字内容
    createSQL = [createSQL stringByAppendingString:@" large_url TEXT,"];//图片内容
    createSQL = [createSQL stringByAppendingString:@" width INTEGER,"];//图片宽度
    createSQL = [createSQL stringByAppendingString:@" height INTEGER,"];//图片高度
    createSQL = [createSQL stringByAppendingString:@" gif_mark INTEGER,"];//图片是否为gif，0为不是gif，1是gif
    
    createSQL = [createSQL stringByAppendingString:@" favorite_count INTEGER,"];
    createSQL = [createSQL stringByAppendingString:@" bury_count INTEGER,"];//
    createSQL = [createSQL stringByAppendingString:@" comments_count INTEGER,"];//
    
    createSQL = [createSQL stringByAppendingString:@" collect_time INTEGER"];
    createSQL = [createSQL stringByAppendingString:@");"];
    
    [db executeUpdate:createSQL];
    
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
    createSQL = [createSQL stringByAppendingString:@" large_url TEXT,"];//图片内容
    createSQL = [createSQL stringByAppendingString:@" width INTEGER,"];//图片宽度
    createSQL = [createSQL stringByAppendingString:@" height INTEGER,"];//图片高度
    createSQL = [createSQL stringByAppendingString:@" gif_mark INTEGER,"];//图片是否为gif，0为不是gif，1是gif

    createSQL = [createSQL stringByAppendingString:@" favorite_count INTEGER,"];
    createSQL = [createSQL stringByAppendingString:@" bury_count INTEGER,"];//
    createSQL = [createSQL stringByAppendingString:@" comments_count INTEGER,"];//
    
    createSQL = [createSQL stringByAppendingString:@" collect_time INTEGER"];
    createSQL = [createSQL stringByAppendingString:@");"];

    [db executeUpdate:createSQL];
    
}

- (NSString *)getMogoAppKey {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"MoGoAppKey"];
}

- (NSString *)getUmengAppKey {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"UmengAppKey"];
}

- (NSString *)getNewTabCid {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"NewTabCid"];
}

- (NSString *)getAppStoreId {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"AppStoreId"];
}

- (NSString *)getAppChannelTag {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"AppChannelTag"];
}

- (NSString *)getAlertKeyword {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    return [appConfig objectForKey:@"AlertKeyword"];
}

- (UIColor *)getTitleTextColor {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    NSDictionary *titleTextColor =  [appConfig objectForKey:@"TitleTextColor"];
    NSNumber *redNumber = (NSNumber *)[titleTextColor objectForKey:@"red"];
    NSNumber *greenNumber = (NSNumber *)[titleTextColor objectForKey:@"green"];
    NSNumber *blueNumber = (NSNumber *)[titleTextColor objectForKey:@"blue"];
    UIColor *result = [UIColor colorWithRed:[redNumber floatValue]/255.0f 
                                      green:[greenNumber floatValue]/225.0f 
                                       blue:[blueNumber floatValue]/255.0f 
                                      alpha:1]; 
    return result;
}

- (UIColor *)getTitleShadowColor {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    NSDictionary *titleShadowColor =  [appConfig objectForKey:@"TitleShadowColor"];
    NSNumber *redNumber = (NSNumber *)[titleShadowColor objectForKey:@"red"];
    NSNumber *greenNumber = (NSNumber *)[titleShadowColor objectForKey:@"green"];
    NSNumber *blueNumber = (NSNumber *)[titleShadowColor objectForKey:@"blue"];
    UIColor *result = [UIColor colorWithRed:[redNumber floatValue]/255.0f 
                                      green:[greenNumber floatValue]/225.0f 
                                       blue:[blueNumber floatValue]/255.0f 
                                      alpha:1]; 
    return result;
}
- (BOOL)getShowImageDefault {
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    NSNumber *showImageDefault = (NSNumber *)[appConfig objectForKey:@"ShowImageDefault"];
    return [showImageDefault boolValue];
}

//是否处于审核模式
- (BOOL)isInReview {
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *versionForReview = [MobClick getConfigParams:@"versionForReview"];
    
    BOOL inReview = NO;
    if ([currentAppVersion isEqualToString:versionForReview]) {
        inReview = YES;
    }
    
    if (versionForReview == nil || versionForReview == [NSNull null]  || [versionForReview isEqualToString:@""]) {
        inReview = YES;
    }
    return inReview;
}

- (BOOL)isAdmin {
    PFUser *user = [PFUser currentUser];
    if (user && [user.username isEqualToString:@"drawinghelper@gmail.com"])
        return YES;
    return NO;
}

//创建待发送的热度计分表
- (void)createScoreTable {
    FMDatabase *db= [FMDatabase databaseWithPath:[self getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    }
    
    //创建一个名为User的表，有两个字段分别为string类型的Name，integer类型的 Age
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS filtered_score (";
	createSQL = [createSQL stringByAppendingString:@" ID INTEGER PRIMARY KEY AUTOINCREMENT,"];
    
    createSQL = [createSQL stringByAppendingString:@" weiboId INTEGER UNIQUE,"];//微博的id
	createSQL = [createSQL stringByAppendingString:@" profile_image_url TEXT,"];//博主头像图片地址
    createSQL = [createSQL stringByAppendingString:@" screen_name TEXT,"];//微博名
    createSQL = [createSQL stringByAppendingString:@" timestamp INTEGER,"];//微博发表时间
    
	createSQL = [createSQL stringByAppendingString:@" content TEXT,"];//文字内容
    createSQL = [createSQL stringByAppendingString:@" large_url TEXT,"];//图片内容
    createSQL = [createSQL stringByAppendingString:@" width INTEGER,"];//图片宽度
    createSQL = [createSQL stringByAppendingString:@" height INTEGER,"];//图片高度
    createSQL = [createSQL stringByAppendingString:@" gif_mark INTEGER,"];//图片是否为gif，0为不是gif，1是gif
    
    createSQL = [createSQL stringByAppendingString:@" favorite_count INTEGER,"];
    createSQL = [createSQL stringByAppendingString:@" bury_count INTEGER,"];//
    createSQL = [createSQL stringByAppendingString:@" comments_count INTEGER,"];//
    
    //-
    //createSQL = [createSQL stringByAppendingString:@" collect_time INTEGER"];
    //+
    createSQL = [createSQL stringByAppendingString:@" share_url TEXT UNIQUE,"];//微博的id
    createSQL = [createSQL stringByAppendingString:@" score_to_send INTEGER"];
    createSQL = [createSQL stringByAppendingString:@");"];
    
    [db executeUpdate:createSQL];
}

- (void)scoreForShareUrl:(NSDictionary *)currentDuanZi action:(UIAction)action {
    [self scoreForShareUrl:currentDuanZi channel:UIChannelHistory action:action];
}
//为对应记录加分
- (void)scoreForShareUrl:(NSDictionary *)currentDuanZi channel:(UIChannel)channel action:(UIAction)action {
    int actionFactor, channelFactor;
    NSString *shareurl = [currentDuanZi objectForKey:@"shareurl"];
    switch (action) {
        case UIActionShare:
            actionFactor = 5;
            break;
        case UIActionCollect:
            actionFactor = 3;
            break;
        case UIActionView:
            actionFactor = 1;
            break;
        default:
            break;
    }
    switch (channel) {
        case UIChannelNew:
            channelFactor = 3;
            break;
        case UIChannelMagzine:
            channelFactor = 2;
            break;
        case UIChannelHistory:
            channelFactor = 1;
        default:
            break;
    }
    int score = actionFactor * channelFactor;
    
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    } 
    
    NSString *sql = [[NSString alloc] initWithFormat:@"SELECT * FROM filtered_score WHERE share_url = '%@'", shareurl];
    FMResultSet *rs=[db executeQuery:sql];
    NSArray *dataArray = nil;
    if ([rs next]){ //filtered_score表中如果有shareurl的记录，就直接加分
        dataArray = [NSArray arrayWithObjects:
                         [[NSNumber alloc] initWithInt:score],
                         shareurl,
                         nil
                         ];
        [db executeUpdate:@"update filtered_score set score_to_send = score_to_send + ? where share_url = ?" withArgumentsInArray:dataArray];
    } else {  //filtered_score表中没有shareurl的记录，需要插入此记录
        NSDate *nowDate = [[NSDate alloc] init];
        dataArray = [NSArray arrayWithObjects:
                          [currentDuanZi objectForKey:@"id"], 
                          [currentDuanZi objectForKey:@"profile_image_url"], 
                          [currentDuanZi objectForKey:@"screen_name"],
                          [currentDuanZi objectForKey:@"timestamp"],
                          [currentDuanZi objectForKey:@"content"],
                          
                          [currentDuanZi objectForKey:@"large_url"], 
                          [currentDuanZi objectForKey:@"width"],
                          [currentDuanZi objectForKey:@"height"],
                          [[NSNumber alloc] initWithInt:0],
                          
                          [currentDuanZi objectForKey:@"favorite_count"], 
                          [currentDuanZi objectForKey:@"bury_count"],
                          [currentDuanZi objectForKey:@"comments_count"],
                          [currentDuanZi objectForKey:@"shareurl"],
                          [[NSNumber alloc] initWithInt:score],
                          nil
                          ];
        
        //score表中如果没有shareurl的记录，就为此shareurl建立分数档案
        [db executeUpdate:@"replace into filtered_score(weiboId, profile_image_url, screen_name, timestamp, content, large_url, width, height, gif_mark, favorite_count, bury_count, comments_count,  share_url, score_to_send) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:dataArray];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *appConfig = [[NSDictionary alloc] initWithContentsOfFile:
                               [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]];
    NSDictionary *parseConfig = [appConfig objectForKey:@"ParseConfig"]; 
    [Parse setApplicationId:[parseConfig objectForKey:@"applicationId"]
                  clientKey:[parseConfig objectForKey:@"clientKey"]];
    
    // Set defualt ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    // Register for notifications
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert)];
    
    [MobClick startWithAppkey:[[NoneAdultAppDelegate sharedAppDelegate] getUmengAppKey] reportPolicy:REALTIME channelId:[[NoneAdultAppDelegate sharedAppDelegate] getAppChannelTag]];
    [MobClick checkUpdate];
    [MobClick updateOnlineConfig];
    
    [self createScoreTable];
    [self createDingTable];
    [self createCollectTable];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    UIViewController *newCommonViewController = [[NewCommonViewController alloc] 
                                                 initWithNibName:@"NewCommonViewController" 
                                                 bundle:nil 
                                                 withTitle:@"最新" 
                                                 withCid:[[NoneAdultAppDelegate sharedAppDelegate] getNewTabCid]];
    UINavigationController *newCommonNavViewController = [[UINavigationController alloc] initWithRootViewController:newCommonViewController];
    
    UIViewController *newPathViewController = [[NewPathViewController alloc] init];
    UINavigationController *newPathNavViewController = [[UINavigationController alloc] initWithRootViewController:newPathViewController];
    
    HistoryPathViewController *historyTopController = [[HistoryPathViewController alloc] init];
    UINavigationController *historyTopNavViewController = [[UINavigationController alloc] initWithRootViewController:historyTopController];
    
    UIViewController *searchController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    
    ChannelViewController *channelController = [[ChannelViewController alloc] init];
    UINavigationController *channelNavViewController = [[UINavigationController alloc] initWithRootViewController:channelController];
    
    UIViewController *collectViewController = [[CollectedViewController alloc] initWithNibName:@"CollectedViewController" bundle:nil withTitle:@"收藏"];
    UINavigationController *collectNavViewController = [[UINavigationController alloc] initWithRootViewController:collectViewController];
    [collectNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];

    UIViewController *settingViewController = [[NoneAdultSettingViewController alloc] initWithNibName:@"NoneAdultSettingViewController" bundle:nil];
    UINavigationController *settingNavViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [settingNavViewController.navigationBar setTintColor:[UIColor darkGrayColor]];
    
    CMTabBarController *tabBarController = [CMTabBarController new];
    //self.tabBarController = [[UITabBarController alloc] init];
    
    NSString *showChannel = [MobClick getConfigParams:@"showChannel"];
    if (showChannel == nil || showChannel == [NSNull null]  || [showChannel isEqualToString:@""]) {
        showChannel = @"NO";
    }
    
    //为过审和推广初期内容高质量，只显示精选；之后可以显示未精选过的最新笑话
    if ([[NoneAdultAppDelegate sharedAppDelegate] isAdmin]) {
        tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                 newCommonNavViewController, 
                                                 newPathNavViewController,
                                                 historyTopNavViewController,
                                                 channelNavViewController,
                                                 collectNavViewController,
                                                 //searchController,
                                                 settingNavViewController,
                                                 nil];
    } else {
        if ([[NoneAdultAppDelegate sharedAppDelegate] isInReview]) {
            tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                         newPathNavViewController,
                                                         historyTopNavViewController,
                                                         channelNavViewController,
                                                         collectNavViewController,
                                                         //searchController,
                                                         settingNavViewController,
                                                         nil];
            if ([showChannel isEqualToString:@"NO"]) {
                tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                         newPathNavViewController,
                                                         historyTopNavViewController,
                                                         //channelNavViewController,
                                                         collectNavViewController,
                                                         //searchController,
                                                         settingNavViewController,
                                                         nil];
            }
        } else {
            tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                     newCommonNavViewController, 
                                                     historyTopNavViewController,
                                                     channelNavViewController,
                                                     collectNavViewController,
                                                     //searchController,
                                                     settingNavViewController,
                                                     nil];
            if ([showChannel isEqualToString:@"NO"]) {
                tabBarController.viewControllers = [NSArray arrayWithObjects:
                                                         newCommonNavViewController, 
                                                         historyTopNavViewController,
                                                         //channelNavViewController,
                                                         collectNavViewController,
                                                         //searchController,
                                                         settingNavViewController,
                                                         nil];
            }
        }
    }
        
    self.window.rootViewController = tabBarController;
    [NSThread sleepForTimeInterval:1.0];
    [self.window makeKeyAndVisible];
    [self animateSplashScreen];

    [Appirater appLaunched:YES];
    
    application.applicationIconBadgeNumber = 0;
    [self buryRoutineNotification];
    
    return YES;
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    application.applicationIconBadgeNumber = 0;
    //从push过来默认来最热tab
    //[self.tabBarController setSelectedIndex:1];
    [PFPush handlePush:userInfo];
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
    NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:60*60*24];
    NSCalendar *chineseCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *tomorrowComponents = [chineseCalendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:tomorrow];  
    NSLog(@"year: %d, month: %d, day: %d", 
          [tomorrowComponents year],
          [tomorrowComponents month],
          [tomorrowComponents day]);
    
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init]; 
    [offsetComponents setYear:[tomorrowComponents year]];
    [offsetComponents setMonth:[tomorrowComponents month]];
    [offsetComponents setDay:[tomorrowComponents day]];
    [offsetComponents setHour:20];
    
    NSDate *tomorrow20dian = [chineseCalendar dateFromComponents:offsetComponents];  
    
    //创建一个本地推送
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti) {
        //设置推送时间
        noti.fireDate = tomorrow20dian;
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
        noti.alertBody = [NSString stringWithFormat:@"今天又有新%@啦，来看看吧！",
                          [[NoneAdultAppDelegate sharedAppDelegate] getAlertKeyword]];
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
    NSLog(@"applicationDidBecomeActive...");
    //1. 按照score表中的分数上传parse
    //1.1 找到需要更新的parseobject
    //1.2 使用incrementKey:byAmount:为新的score
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    } 
    
    NSString *remoteTableName = nil;
    if ([[NoneAdultAppDelegate sharedAppDelegate] isInReview]) {
        remoteTableName = @"admin_filtered";
    } else {
        remoteTableName = @"user_filtered";
    }
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM filtered_score"];
    while ([rs next]){
        NSString *shareUrl = [rs stringForColumn:@"share_url"];
        int scoreToSend = [rs intForColumn:@"score_to_send"];
        NSLog(@"shareUrl: %@, score to send: %d", shareUrl, scoreToSend);

        NSNumber *weiboId = [[NSNumber alloc] initWithLongLong:[rs longLongIntForColumn:@"weiboId"]];
        NSString *profileImageUrl = [rs stringForColumn:@"profile_image_url"];
        NSString *screenName = [rs stringForColumn:@"screen_name"];
        NSNumber *timestamp = [[NSNumber alloc] initWithInt:[rs intForColumn:@"timestamp"]];
        NSString *content = [rs stringForColumn:@"content"];
        NSString *largeUrl = [rs stringForColumn:@"large_url"];
        
        NSNumber *width = [[NSNumber alloc] initWithInt:[rs intForColumn:@"width"]];
        NSNumber *height = [[NSNumber alloc] initWithInt:[rs intForColumn:@"height"]];
        NSNumber *gifMark = [[NSNumber alloc] initWithInt:[rs intForColumn:@"gif_mark"]];
        NSNumber *favoriteCount = [[NSNumber alloc] initWithInt:[rs intForColumn:@"favorite_count"]];
        NSNumber *buryCount = [[NSNumber alloc] initWithInt:[rs intForColumn:@"bury_count"]];        
        NSNumber *commentsCount = [[NSNumber alloc] initWithInt:[rs intForColumn:@"comments_count"]];
                
        //服务器上表中已有此记录，直接在此记录上加分；否则，插入此记录
        PFQuery *query = [PFQuery queryWithClassName:remoteTableName];
        [query whereKey:@"shareurl" equalTo:shareUrl];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                if (objects.count > 0) {
                    PFObject *object = [objects objectAtIndex:0];
                    
                    [object incrementKey:@"score" byAmount:[NSNumber numberWithInt:scoreToSend]];
                    [object saveEventually];
                } else {
                    PFObject *newFiltered = [PFObject objectWithClassName:remoteTableName];
                    [newFiltered setObject:weiboId forKey:@"weiboId"];
                    [newFiltered setObject:profileImageUrl forKey:@"profile_image_url"];
                    [newFiltered setObject:screenName forKey:@"screen_name"];
                    [newFiltered setObject:timestamp forKey:@"timestamp"];
                    [newFiltered setObject:content forKey:@"content"];
                    [newFiltered setObject:largeUrl forKey:@"large_url"];
                    
                    [newFiltered setObject:width forKey:@"width"];
                    [newFiltered setObject:height forKey:@"height"];
                    [newFiltered setObject:gifMark forKey:@"gif_mark"];
                    
                    [newFiltered setObject:favoriteCount forKey:@"favorite_count"];
                    [newFiltered setObject:buryCount forKey:@"bury_count"];
                    [newFiltered setObject:commentsCount forKey:@"comments_count"];
                    [newFiltered setObject:shareUrl forKey:@"shareurl"];
                    [newFiltered setObject:[[NSNumber alloc] initWithInt:scoreToSend] forKey:@"score"];                
                    
                    PFACL *groupACL = [PFACL ACL];
                    [groupACL setPublicWriteAccess:YES];
                    [groupACL setPublicReadAccess:YES];
                    newFiltered.ACL = groupACL;
                    
                    [newFiltered saveEventually];
                }
            } else {
                // Log details of the failure
                NSLog(@"%@",[error description]);
            }
        }];    
    }
    //2. 清空本地score表中的已有记录
    [db executeUpdate:@"delete from filtered_score"];
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
