//
//  NoneAdultSecondViewController.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultSecondViewController.h"

@interface NoneAdultSecondViewController ()

@end

@implementation NoneAdultSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"已收藏", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"collect"];
        
        UILabel *label = (UILabel *)self.navigationItem.titleView;
        [label setText:NSLocalizedString(@"已收藏", @"Second")];
    }
    return self;
}

- (void)requestResultFromServer {
    NSLog(@"NoneAdultSecondViewController.requestResultFromServer...");
    //[HUD hide:YES afterDelay:0];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    NSMutableSet *resultSet = [[NSMutableSet alloc] init];
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    } 

    NSMutableArray *addedList = [[NSMutableArray alloc] init];
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM collected"];
    NSMutableDictionary *dic = nil;
    while ([rs next]){
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[rs stringForColumn:@"screen_name"] forKey:@"nick"];
        [dic setObject:[rs stringForColumn:@"profile_image_url"] forKey:@"pic"];
        NSNumber *number = [[NSNumber alloc] initWithInt:[rs intForColumn:@"timestamp"]];
        [dic setObject:number forKey:@"timestamp"];
        [dic setObject:[rs stringForColumn:@"content"] forKey:@"content"];

        number = [[NSNumber alloc] initWithInt:[rs intForColumn:@"favorite_count"]];
        [dic setObject:number forKey:@"count"];
        number = [[NSNumber alloc] initWithInt:[rs intForColumn:@"bury_count"]];
        [dic setObject:number forKey:@"bury_count"];
        number = [[NSNumber alloc] initWithInt:[rs intForColumn:@"comments_count"]];
        [dic setObject:number forKey:@"comments_count"];

        [addedList addObject:dic];
    }
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:addedList waitUntilDone:NO];
    
    /*
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(responseString);
    NSDictionary *responseInfo = [UMSNSStringJson JSONValue:responseString]; 
    NSDictionary *dataDic = [responseInfo objectForKey:@"info"];
    NSMutableArray *addedList = [dataDic objectForKey:@"talk"];
    tempPropertyDic = [dataDic objectForKey:@"selectedMap"];
    NSLog(@"result: %@", addedList);
    
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:addedList waitUntilDone:NO];
     */
    
}
/*
- (void)loadUrl {
    NSString *configContentsource = [[NoneAdultAppDelegate sharedAppDelegate] getConfigContentsource];
    if ([configContentsource isEqualToString:@"0"]) {
        url = [[NSString alloc] initWithString:@"http://211.157.111.244:6090/hot.json?tag=joke&offset=0&count=100"];
    } else if ([configContentsource isEqualToString:@"1"]) {
        url = [[NSString alloc] initWithString:@"http://nh.tourbox.me/hot.json?tag=joke&offset=0&count=100"];
    } else {
        url = [[NSString alloc] initWithString:@"http://i.snssdk.com/essay/1/top/?tag=joke&offset=0&count=100"];
    }
    NSLog(@"loadUrl: %@", url);
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    canLoadNew = NO;
    canLoadOld = NO;
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [self performRefresh];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
