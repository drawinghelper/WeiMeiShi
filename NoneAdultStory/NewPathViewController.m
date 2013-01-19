//
//  HistoryPathViewController.m
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import "NewPathViewController.h"
#import "UITabBarController+hidable.h"

@implementation NewPathViewController
{
    CGFloat startContentOffset;
    CGFloat lastContentOffset;
    BOOL hidden;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
    //NSLog(@"scrollViewWillBeginDragging: %f", scrollView.contentOffset.y);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView 
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromStart = startContentOffset - currentOffset;
    CGFloat differenceFromLast = lastContentOffset - currentOffset;
    lastContentOffset = currentOffset;
    
    if((differenceFromStart) < 0)
    {
        // scroll up
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self expand];
    }
    else {
        if(scrollView.isTracking && (abs(differenceFromLast)>1))
            [self contract];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self contract];
    return YES;
}

#pragma mark - The Magic!

-(void)expand
{
    if(hidden)
        return;
    
    hidden = YES;
    
    [self.tabBarController setTabBarHidden:YES 
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:YES 
                                             animated:YES];
}

-(void)contract
{
    if(!hidden)
        return;
    
    hidden = NO;
    
    [self.tabBarController setTabBarHidden:NO 
                                  animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO 
                                             animated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = NSLocalizedString(@"最新精选", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"new"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [[NoneAdultAppDelegate sharedAppDelegate] getTitleShadowColor];     
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [[NoneAdultAppDelegate sharedAppDelegate] getTitleTextColor];          
        [label setShadowOffset:CGSizeMake(0, 1.0)];
        
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"最新精选", @"");
        [label sizeToFit];
        
        // Custom the table
        // The className to query on
        self.className = @"admin_filtered";
        
        // The key of the PFObject to display in the label of the default cell style
        //self.keyToDisplay = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 10;
    }
    return self;
}
#pragma mark - View lifecycle
//处理应用内消息
- (void)processPullMessage {
    NSString *pullmessage = [MobClick getConfigParams:@"pullmessage"];
    if (pullmessage != nil 
        && pullmessage != [NSNull null]
        && ![pullmessage isEqualToString:@""]) {
        
        pullmessageInfo = [UMSNSStringJson JSONValue:pullmessage]; 
        NSString *pullmessageTimestamp = [pullmessageInfo objectForKey:@"timestamp"];
        
        //1. 读取已展现消息的时间戳数组
        NSMutableArray *showedMessageTimestampArray = [[NSMutableArray alloc] init];
        NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
        NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:@"showedMessageTimestampArray"];
        if (dataRepresentingSavedArray != nil)
        {
            NSArray *oldSavedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (oldSavedArray != nil)
                showedMessageTimestampArray = [[NSMutableArray alloc] initWithArray:oldSavedArray];
            else
                showedMessageTimestampArray = [[NSMutableArray alloc] init];
        }
        
        //2. 遍历时间戳数组，与本次消息的时间戳做对比
        BOOL showedTag = NO;
        for (int i = 0; i < [showedMessageTimestampArray count]; i++) {
            NSString *showedMessageTimestamp = [showedMessageTimestampArray objectAtIndex:i];
            if ([showedMessageTimestamp isEqualToString:pullmessageTimestamp]) {
                showedTag = YES;
                break;
            }
        }
        
        //是否匹配渠道与版本号
        NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
        NSString *channelId = [[NoneAdultAppDelegate sharedAppDelegate] getAppChannelTag];
        NSString *pullmessageChannelIdList = [pullmessageInfo objectForKey:@"channelId"];
        NSString *pullmessageAppversionList = [pullmessageInfo objectForKey:@"appversion"];
        BOOL channelTargeted = NO;
        if ([pullmessageChannelIdList isEqualToString:@""]
            ||[pullmessageChannelIdList rangeOfString:channelId].length > 0 ) {
            channelTargeted = YES;
        }
        BOOL versionTargeted = NO;
        if ([pullmessageAppversionList isEqualToString:@""]
            ||[pullmessageAppversionList rangeOfString:currentAppVersion].length > 0 ) {
            versionTargeted = YES;
        }
        
        if (versionTargeted && channelTargeted) {
            //3. 无匹配项，则显示此消息
            if (!showedTag) {
                UIAlertView *pullmessageAlertView = [[UIAlertView alloc] initWithTitle:[pullmessageInfo objectForKey:@"title"]
                                                                               message:[pullmessageInfo objectForKey:@"message"]
                                                                              delegate:self
                                                                     cancelButtonTitle:[pullmessageInfo objectForKey:@"canceltitle"]
                                                                     otherButtonTitles:[pullmessageInfo objectForKey:@"oktitle"], nil];
                [pullmessageAlertView show];
                
                [showedMessageTimestampArray addObject:pullmessageTimestamp];
                [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:showedMessageTimestampArray] forKey:@"showedMessageTimestampArray"];
            }
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {          
            // they want to rate it
            NSString *cancelUrl = [pullmessageInfo objectForKey:@"cancelurl"];
            if (![cancelUrl isEqualToString:@""]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cancelUrl]];
            }
            break;
        }
        case 1:
        {
            NSString *okUrl = [pullmessageInfo objectForKey:@"okurl"];
            if (![okUrl isEqualToString:@""]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:okUrl]];
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    [self processPullMessage];
    
    UIButton *btnRefresh = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnRefresh.frame = CGRectMake(0, 0, 44, 44);
    [btnRefresh addTarget:self action:@selector(performRefresh) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnImage = [UIImage imageNamed:@"refresh.png"];
    [btnRefresh setImage:btnImage forState:UIControlStateNormal];
    
    UIButton *btnLianMeng = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLianMeng.frame = CGRectMake(0, 0, 55, 30);
    [btnLianMeng addTarget:self action:@selector(showLianMeng) forControlEvents:UIControlEventTouchUpInside];
    [btnLianMeng setTitle:@"推荐(1)" forState:UIControlStateNormal];
    [btnLianMeng setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btnLianMeng setBackgroundImage:[UIImage imageNamed:@"lianmengbutton.png"] forState:UIControlStateNormal];
    [btnLianMeng.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
    [btnLianMeng.titleLabel setShadowOffset:CGSizeMake(0, 0.2f)];
    [btnLianMeng.titleLabel setShadowColor:[UIColor lightGrayColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnLianMeng];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRefresh];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] 
                                                  forBarMetrics:UIBarMetricsDefault]; 
    
    self.tableView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1];
}
- (void)showLianMeng {
    UMTableViewDemo *lianMengViewController = [[UMTableViewDemo alloc]init];
    lianMengViewController.title = @"精彩应用推荐";
    lianMengViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lianMengViewController animated:YES];
}
- (void)performRefresh {
    [self loadObjects];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadCollectedIds];
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self contract];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [HUD hide:YES afterDelay:0];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    NSLog(@"加载完成...");
    
    [self loadCollectedIds];
    /*NSMutableDictionary *dic = nil;
    newObjectArray = [[NSMutableArray alloc] init];
    for (int i=0;i<[self.objects count];i++) {
        dic = [self.objects objectAtIndex:i];
        [self adaptDic:dic];
        [self checkCollected:dic];
        [newObjectArray addObject:dic];
    }
     */
    [self.tableView reloadData];
}

//- (void)adaptDic:(NSMutableDictionary *)dic {
//    NSString *idString = [dic objectForKey:@"weiboId"];
//    [dic setObject:idString forKey:@"id"];
//}

/*- (void)checkCollected:(NSMutableDictionary *)dic {
    
    NSString *idString = [dic objectForKey:@"weiboId"];
    
    if ([collectedIdsDic objectForKey:idString] != nil) {
        NSLog(@"idString YES: %@", idString);
        [dic setObject:@"YES" forKey:@"collected_tag"];
    } else {
        NSLog(@"idString NO: %@", idString);
        [dic setObject:@"NO" forKey:@"collected_tag"];
    }
}*/

- (void)objectsWillLoad {
    [super objectsWillLoad];
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.labelText = @"努力加载中...";
    [HUD setOpacity:0.6f];
    
    // This method is called before a PFQuery is fired to get more objects
    NSLog(@"开始加载...");
}

- (void)loadCollectedIds {
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    } 
    
    collectedIdsDic = [[NSMutableDictionary alloc] init];
    FMResultSet *rs=[db executeQuery:@"SELECT * FROM collected ORDER BY collect_time DESC"];
    while ([rs next]){
        NSString *weiboId = [NSString stringWithFormat:@"%lld", [rs longLongIntForColumn:@"weiboId"]];
        [collectedIdsDic setObject:[[NSNumber alloc] initWithInt:1] forKey:weiboId];
    }
}

-(void)goShare:(id)sender{  
    //这个sender其实就是UIButton，因此通过sender.tag就可以拿到刚才的参数  
    int i = [sender tag] - 1000;
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
    currentDuanZi = [self objectAtIndex:currentIndexPath];
    [self shareDuanZi];
}

-(void)goCollect:(id)sender{  
    //这个sender其实就是UIButton，因此通过sender.tag就可以拿到刚才的参数  
    int i = [sender tag] - 2000;
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
    currentDuanZi = [self objectAtIndex:currentIndexPath];
    
    BOOL tag = YES;
    NSString *collectedTag = [currentDuanZi objectForKey:@"collected_tag"];
    if ([collectedTag isEqual:@"YES"]) {
        tag = NO;
        [currentDuanZi setObject:@"NO" forKey:@"collected_tag"];
    } else {
        tag = YES;
        [currentDuanZi setObject:@"YES" forKey:@"collected_tag"];
    }
    [self toggleCollect:tag withSender:sender];
    [self collectDuanZi:tag];
    [self collectHUDMessage:tag];   
}

- (void)shareDuanZi {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到" 
                                                             delegate:self
                                                    cancelButtonTitle:@"取消" 
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"复制文本",@"保存图片",@"新浪微博",@"腾讯微博", nil];     
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)toggleCollect:(BOOL)tag withSender:(id)sender {
    UIButton *heartButton = (UIButton *)sender;
    UIImage *btnStarImage = [UIImage imageNamed:@"star.png"];
    UIImage *btnStarImagePressed = [UIImage imageNamed:@"star_pressed.png"];
    if (tag) {
        [heartButton setImage:btnStarImagePressed forState:UIControlStateNormal];
        [heartButton setImage:btnStarImage forState:UIControlStateHighlighted];
    } else {
        [heartButton setImage:btnStarImage forState:UIControlStateNormal];
        [heartButton setImage:btnStarImagePressed forState:UIControlStateHighlighted];
    }
}

- (void)collectDuanZi:(BOOL)tag {
    FMDatabase *db= [FMDatabase databaseWithPath:[[NoneAdultAppDelegate sharedAppDelegate] getDbPath]] ;  
    if (![db open]) {  
        NSLog(@"Could not open db."); 
        return ;  
    }
    if (tag) {
        NSDate *nowDate = [[NSDate alloc] init];
        NSArray *dataArray = [NSArray arrayWithObjects:
                              [currentDuanZi objectForKey:@"weiboId"], 
                              
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
                              [[NSNumber alloc] initWithLongLong:[nowDate timeIntervalSince1970]],
                              //[currentDuanZi objectForKey:@"collect_time"],
                              nil
                              ];
        [db executeUpdate:@"replace into collected(weiboId, profile_image_url, screen_name, timestamp, content, large_url, width, height, gif_mark, favorite_count, bury_count, comments_count, collect_time) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)" withArgumentsInArray:dataArray];
    } else {
        NSArray *dataArray = [NSArray arrayWithObjects:[currentDuanZi objectForKey:@"weiboId"], nil];
        [db executeUpdate:@"delete from collected where weiboId = ?" withArgumentsInArray:dataArray];
    }
}

/*
 YES - 收藏成功，
 NO - 取消收藏
 */
-(void)collectHUDMessage:(BOOL)tag{
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
	HUD.mode = MBProgressHUDModeText;
    if (tag) {
        HUD.labelText = @"收藏成功";
    } else {
        HUD.labelText = @"取消收藏";
    }
	HUD.margin = 10.f;
	HUD.yOffset = 150.f;
	HUD.removeFromSuperViewOnHide = YES;
	[HUD hide:YES afterDelay:1];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        NSString *weiboContent = [currentDuanZi objectForKey:@"content"];
        NSString *statusContent = weiboContent;
        NSString *postfix = [NSString stringWithFormat:@" (来自 %@ )",
                             [[NoneAdultAppDelegate sharedAppDelegate] getShareProfix]
                             ];
        int contentMaxLength = 140 - postfix.length;
        
        if ([statusContent length] > contentMaxLength) {
            statusContent = [statusContent substringToIndex:contentMaxLength];
        }
        statusContent = [statusContent stringByAppendingString:postfix];
        
        NSString *largeUrl = [currentDuanZi objectForKey:@"large_url"];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        UIImage *shareImage = [manager imageWithURL:[NSURL URLWithString:largeUrl]];
        currentImage = shareImage;
        
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            NSLog(@"custom event share_email!");
            /*[MobClick event:@"share_email"];
             [self emailPhoto]; 
             */
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = weiboContent;
            [self showHUDWithMessage:@"文本已复制"];
            
            return; 
            
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
            NSLog(@"保存图片!");
            [self savePhoto];
            return;
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
            
            NSLog(@"custom event share_sina_budong!");
            /*[MobClick event:@"share_sina_budong"];*/
            [UMSNSService presentSNSInController:self 
                                          appkey:[[NoneAdultAppDelegate sharedAppDelegate] getUmengAppKey] 
                                          status:statusContent 
                                           image:shareImage 
                                        platform:UMShareToTypeSina];
            
            [UMSNSService setDataSendDelegate:self];
            return;
        } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 3) {
            NSLog(@"custom event share_sina_haoxiao!");            
            [UMSNSService presentSNSInController:self 
                                          appkey:[[NoneAdultAppDelegate sharedAppDelegate] getUmengAppKey] 
                                          status:statusContent 
                                           image:shareImage 
                                        platform:UMShareToTypeTenc];
            
            [UMSNSService setDataSendDelegate:self];
            return;
        }
    }
}


- (void)savePhoto {
    if (currentImage) {
        [self showProgressHUDCompleteMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"正在保存至相册", @"Displayed with ellipsis as 'Saving...' when an item is in the process of being saved")]];
    }
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = message;
	
	[HUD showWhileExecuting:@selector(actuallySavePhoto:) onTarget:self withObject:currentImage animated:YES];
    //self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)actuallySavePhoto:(UIImage *)photo {
    if (photo) {
        sleep(1);
        UIImageWriteToSavedPhotosAlbum(photo, self, 
                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    //[self showProgressHUDCompleteMessage: error ? NSLocalizedString(@"Failed", @"Informing the user a process has failed") : NSLocalizedString(@"Saved", @"Informing the user an item has been saved")];
}

#pragma mark - Action Sheet Delegate
- (void)dataSendDidFinish:(UIViewController *)viewController andReturnStatus:(UMReturnStatusType)returnStatus andPlatformType:(UMShareToType)platfrom {
    [viewController dismissModalViewControllerAnimated:YES];
}

// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.className];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"timestamp"];
    
    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"点击\n加载更多"]) {
        return 75;
    } else {
        int row = [indexPath row];
        NSDictionary *duanZi = [self.objects objectAtIndex:row];
        CGRect imageDisplayRect = [self getImageDisplayRect:duanZi];    
        
        return cell.frame.size.height + TOP_SECTION_HEIGHT + BOTTOM_SECTION_HEIGHT + imageDisplayRect.size.height;
    }
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"点击\n加载更多";
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont fontWithName:@"STHeiti K" size:14];
    cell.textLabel.textColor = [UIColor colorWithRed:109.0f/255 green:109.0f/225 blue:109.0f/255 alpha:1]; 
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    return cell;
}


- (CGRect)getImageDisplayRect:(NSDictionary *)duanZi {
    CGRect rect;
    
    int imageDisplayLeft = 0;
    int imageDisplayTop = TOP_SECTION_HEIGHT;
    int imageDisplayWidth = 320;
    int imageDisplayHeight = 0;
    
    int width = 0;
    int height = 0;
    if ([[NoneAdultAppDelegate sharedAppDelegate] isNeedShowImage]) {
        width = [[duanZi objectForKey:@"width"] intValue];
        height = [[duanZi objectForKey:@"height"] intValue];
    }
    if (width > (320 - 2*HORIZONTAL_PADDING)) {
        imageDisplayLeft = HORIZONTAL_PADDING;
        imageDisplayWidth = 320 - 2*HORIZONTAL_PADDING;
        imageDisplayHeight = (height * imageDisplayWidth) / width; 
    } else {
        imageDisplayLeft = (320 - width)/2;
        imageDisplayWidth = width;
        imageDisplayHeight = height;
    }
    
    rect.origin.x = imageDisplayLeft; 
    rect.origin.y = imageDisplayTop;
    rect.size.width = imageDisplayWidth; 
    rect.size.height = imageDisplayHeight;
    return rect;
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object. 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)duanZi {
    int row = [indexPath row];
    
    //打上是否收藏过的标记
    NSString *idString = [duanZi objectForKey:@"weiboId"];
    if ([collectedIdsDic objectForKey:idString] != nil) {
        //NSLog(@"idString YES: %@", idString);
        [duanZi setObject:@"YES" forKey:@"collected_tag"];
    } else {
        //NSLog(@"idString NO: %@", idString);
        [duanZi setObject:@"NO" forKey:@"collected_tag"];
    }
    
    //NSMutableDictionary *duanZi = [newObjectArray objectAtIndex:row];
    static NSString *CellIdentifier = @"OffenceCustomCellIdentifier";
    EmailableCell *cell = (EmailableCell *) [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //清除已有数据，防止文字重叠
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    if (cell == nil) {
        cell = [[EmailableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setIndexPath:indexPath];
    [cell setDelegate:self];

    //【顶部】
    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [cell.contentView addSubview:topBgView];
    //[bottomBgView setBackgroundColor:[UIColor lightGrayColor]];
    [topBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"duanzi_bg_top.png"]]];
    [topBgView setFrame:CGRectMake(0, 0, 320, TOP_SECTION_HEIGHT)]; 
    
    //微博名
    UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SECTION_HEIGHT+5, -3, 320 - TOP_SECTION_HEIGHT, TOP_SECTION_HEIGHT)];
    brandNameLabel.textAlignment = UITextAlignmentLeft;
    brandNameLabel.text = [duanZi objectForKey:@"screen_name"];
    brandNameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    brandNameLabel.textColor = [UIColor darkGrayColor];
    brandNameLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:brandNameLabel];
    //发布时间
    UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SECTION_HEIGHT+5, 29, 320 - TOP_SECTION_HEIGHT, TOP_SECTION_HEIGHT-30)];
    timestampLabel.textAlignment = UITextAlignmentLeft;
    NSDecimalNumber *number = (NSDecimalNumber *)[duanZi objectForKey:@"timestamp"];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[number doubleValue]];
    
    NSDateFormatter *dateTimeFormatter=[[NSDateFormatter alloc] init];
    [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    timestampLabel.text = [dateTimeFormatter stringFromDate:date];   
    timestampLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    timestampLabel.textColor = [UIColor darkGrayColor];
    timestampLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:timestampLabel];
    
    //微博头像
    UIImageView *brandLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon.png"]];
    [brandLogoImageView setFrame:CGRectMake(17, 13, TOP_SECTION_HEIGHT-20, TOP_SECTION_HEIGHT-20)];        
    [cell.contentView addSubview:brandLogoImageView];
    [brandLogoImageView setImageWithURL:[NSURL URLWithString:[duanZi objectForKey:@"profile_image_url"]] 
                       placeholderImage:[UIImage imageNamed:@"Icon.png"]];
    CALayer *layer = [brandLogoImageView layer];  
    [layer setMasksToBounds:YES];  
    [layer setCornerRadius:1.5];  
    [layer setBorderWidth:1.0];  
    [layer setBorderColor:[[UIColor clearColor] CGColor]];  
    
    //分享的按钮
    UIButton *btnTwo = [UIButton buttonWithType:UIButtonTypeCustom]; 
    btnTwo.frame = CGRectMake(320 - 15 - 35, 10, 40, 40);
    [btnTwo setTitle:@"" forState:UIControlStateNormal];
    [btnTwo setTag:(row + 1000)];
    
    [btnTwo addTarget:self action:@selector(goShare:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnTwo];
    UIImage *btnImage = [UIImage imageNamed:@"share_normal.png"];
    [btnTwo setImage:btnImage forState:UIControlStateNormal];
    
    //【中部】
    //微博内容
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag = 1;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.highlightedTextColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"STHeiti K" size:14];
    //label.font = [UIFont fontWithName:@"STHeiti SC" size:16];
    label.textColor = [UIColor colorWithRed:109.0f/255 green:109.0f/225 blue:109.0f/255 alpha:1]; 
    
    //[[label layer] setBorderWidth:1.0f];
    //[[label layer] setBorderColor:[NoneAdultAppDelegate getColorFromRed:255 Green:0 Blue:0 Alpha:100]];
    //[[label layer] setBackgroundColor:[NoneAdultAppDelegate getColorFromRed:200 Green:200 Blue:200 Alpha:100]];
    [cell.contentView addSubview:label];
    [cell.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"duanzi_bg_middle.png"]]];
    
    //微博图
    UIImageView *coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"defaultCover.png"]];
    if ([[NoneAdultAppDelegate sharedAppDelegate] isNeedShowImage]) {
        NSString *imageUrl = [duanZi objectForKey:@"large_url"];
        if ( imageUrl != nil && ![imageUrl isEqualToString:@""]) {
            [coverImageView setImageWithURL:[NSURL URLWithString:imageUrl] 
                           placeholderImage:[UIImage imageNamed:@"defaultCover.png"]];
            
            [cell.contentView addSubview:coverImageView];
        }
    }
    
    //【底部】
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [cell.contentView addSubview:bottomBgView];
    //[bottomBgView setBackgroundColor:[UIColor lightGrayColor]];
    [bottomBgView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"duanzi_bg_bottom.png"]]];
    bottomBgView.tag = 1000;
    
    //顶踩评
    UILabel *dingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSDecimalNumber *favoriteCount = (NSDecimalNumber *)[duanZi objectForKey:@"favorite_count"];
    dingLabel.text = [NSString stringWithFormat:@"顶: %@",[favoriteCount stringValue]];
    dingLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [dingLabel setBackgroundColor:[UIColor clearColor]];
    dingLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1];
    [cell.contentView addSubview:dingLabel];
    dingLabel.tag = 2;
    
    UILabel *caiLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSDecimalNumber *buryCount = (NSDecimalNumber *)[duanZi objectForKey:@"bury_count"];
    caiLabel.text = [NSString stringWithFormat:@"踩: %@",[buryCount stringValue]];
    caiLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [caiLabel setBackgroundColor:[UIColor clearColor]];
    caiLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1];
    [cell.contentView addSubview:caiLabel];
    caiLabel.tag = 3;
    
    UILabel *pingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    NSDecimalNumber *commentsCount = (NSDecimalNumber *)[duanZi objectForKey:@"comments_count"];
    pingLabel.text = [NSString stringWithFormat:@"评: %@",[commentsCount stringValue]];
    //pingLabel.textAlignment = UITextAlignmentRight;
    pingLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [pingLabel setBackgroundColor:[UIColor clearColor]];
    pingLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1];
    [cell.contentView addSubview:pingLabel];
    pingLabel.tag = 4;
    
    //收藏按钮
    UIButton *btnStar = [UIButton buttonWithType:UIButtonTypeCustom]; 
    [btnStar setTitle:@"" forState:UIControlStateNormal];
    [btnStar setTag:(row + 2000)];
    [btnStar addTarget:self action:@selector(goCollect:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnStar];
    UIImage *btnStarImage = [UIImage imageNamed:@"star.png"];
    UIImage *btnStarImagePressed = [UIImage imageNamed:@"star_pressed.png"];
    if ([[duanZi objectForKey:@"collected_tag"] isEqual:@"YES"]) {
        [btnStar setImage:btnStarImagePressed forState:UIControlStateNormal];
        [btnStar setImage:btnStarImage forState:UIControlStateHighlighted];
    } else {
        [btnStar setImage:btnStarImage forState:UIControlStateNormal];
        [btnStar setImage:btnStarImagePressed forState:UIControlStateHighlighted];
    }
    
    //content图片内容自适应
    CGRect imageDisplayRect = [self getImageDisplayRect:duanZi];    
    imageDisplayRect.origin.y = imageDisplayRect.origin.y + 5;
    [coverImageView setFrame:imageDisplayRect];
    
    //content内容自适应
    label = (UILabel *)[cell viewWithTag:1];
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(15, TOP_SECTION_HEIGHT + imageDisplayRect.size.height + 8);
    cellFrame.size.width = 320 - 30;
    
    label.text = [duanZi objectForKey:@"content"];
    CGRect rect = CGRectInset(cellFrame, 2, 2);
    label.frame = rect;
    [label sizeToFit];
    cellFrame.size.height = 13 + label.frame.size.height;
    
    
    [bottomBgView setFrame:CGRectMake(0, cellFrame.size.height + imageDisplayRect.size.height + TOP_SECTION_HEIGHT, 320, BOTTOM_SECTION_HEIGHT)];
    
    
    dingLabel = (UILabel *)[cell viewWithTag:2];
    [dingLabel setFrame:CGRectMake(17, cellFrame.size.height + TOP_SECTION_HEIGHT - 3 + imageDisplayRect.size.height, 75, BOTTOM_SECTION_HEIGHT)];
    caiLabel = (UILabel *)[cell viewWithTag:3];
    [caiLabel setFrame:CGRectMake(92, cellFrame.size.height + TOP_SECTION_HEIGHT - 3 + imageDisplayRect.size.height, 75, BOTTOM_SECTION_HEIGHT)];
    pingLabel = (UILabel *)[cell viewWithTag:4];
    [pingLabel setFrame:CGRectMake(165, cellFrame.size.height + TOP_SECTION_HEIGHT - 3 + imageDisplayRect.size.height, 75, BOTTOM_SECTION_HEIGHT)];
    
    [btnStar setFrame:CGRectMake(260, cellFrame.size.height + TOP_SECTION_HEIGHT - 3 + imageDisplayRect.size.height, 320-260, BOTTOM_SECTION_HEIGHT)];
    
    [cell setFrame:cellFrame];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return cell;
}

#pragma mark -
#pragma mark EmailableCellDelegate Methods

- (NSString *) emailableCell:(EmailableCell *)cell emailAddressForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *duanzi = [self.objects objectAtIndex:indexPath.row];
    return [duanzi objectForKey:@"content"];
}

- (void) emailableCell:(EmailableCell *)cell didPressSendEmailOnCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *duanzi = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"indexPath.row: %d", indexPath.row);
    NSString *largeUrl = [duanzi objectForKey:@"large_url"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *shareImage = [manager imageWithURL:[NSURL URLWithString:largeUrl]];
    currentImage = shareImage;
    
    [self savePhoto];
    NSLog(@"保存图片");
}
- (void) emailableCell:(EmailableCell *)cell didFinishCopy:(NSIndexPath *)indexPath {
    NSLog(@"复制好了！");
    [self showHUDWithMessage:@"文本已复制"];
}

- (void)showHUDWithMessage: (NSString *)msgTxt {
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
	
	// Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
	HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	
	// Set custom view mode
	HUD.mode = MBProgressHUDModeCustomView;
	
	HUD.delegate = self;
	HUD.labelText = msgTxt;
	
	[HUD show:YES];
	[HUD hide:YES afterDelay:1];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
}

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath { 
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
