//
//  CollectedViewController.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CollectedViewController.h"

@interface CollectedViewController ()

@end

@implementation CollectedViewController

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
    NSLog(@"CollectedViewController.requestResultFromServer...");
    //[HUD hide:YES afterDelay:0];
    
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    NSMutableSet *resultSet = [[NSMutableSet alloc] init];
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    } 

    NSMutableArray *addedList = [[NSMutableArray alloc] init];
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM collected ORDER BY collect_time DESC"];
    NSMutableDictionary *dic = nil;
    while ([rs next]){
        dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[rs stringForColumn:@"weiboId"] forKey:@"id"];
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
}

-(void)goCollect:(id)sender{  
    [super goCollect:sender];
    //刷新一下本页
    [self performRefresh];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    canLoadNew = NO;
    canLoadOld = NO;
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem = nil;
    firstLoaded = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    if (!firstLoaded) {
        [self performRefresh];
    }
    firstLoaded = NO;
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
