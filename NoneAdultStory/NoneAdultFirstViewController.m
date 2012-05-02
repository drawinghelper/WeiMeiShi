//
//  NoneAdultFirstViewController.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultFirstViewController.h"

@interface NoneAdultFirstViewController ()

@end

@implementation NoneAdultFirstViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"最新段子", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    searchDuanZiList = [[NSMutableArray alloc] init];
    [self requestResultFromServer];

}
- (void)loadUrl {
    url = [[NSString alloc] initWithString:@"http://i.snssdk.com/essay/1/recent/?tag=joke&min_behot_time=0&count=20"];
}

- (void)requestResultFromServer {
	//抽取方法
    NSLog(@"requestResultFromServer...");
    responseData = [NSMutableData data];
    
    //NSLog(@"requestTipInfoFromServer url:%@", url);
    [self loadUrl];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"requestTipInfoFromServer encoded url:%@", url);
	
    NSString *post = nil;  
	post = [[NSString alloc] initWithString:@""];
	NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];  
	NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];  
	[request setURL:[NSURL URLWithString:url]];  
	[request setHTTPMethod:@"GET"]; 
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setHTTPBody:postData];  
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}
#pragma mark -
#pragma mark HTTP Response Methods
//HTTP Response - begin
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {  
    NSLog(@"didReceiveResponse...");
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view setHidden:YES];
    NSLog(@"error: %@", [error description]);
}
/*
 {
     "message": "success",
     "data": [
         {
         "verified_tag": "joke",
         "large_url": "",
         "user_id": 84223809,
         "screen_name": "\u7cd7\u4e8b\u767e\u79d1",     //微博名称
         "bury_count": 0,                               //踩次数
         "profile_image_url": "http://tp1.sinaimg.cn/1850235592/50/5615293852/1", //微博头像
         "timestamp": 1335963205,                       //微博发送时间
         "data_url": "http://weibo.com/1850235592/ybY1U0J88",   //微博地址
         "share_url": "http://www.xiangping.com/detail/e91702210/", 
         "middle_url": "",
         "content": "\u80cc\u666f\u5c0f\u59e8\u5b50\u6700\u8fd1\u8ddf\u8001\u5a46\u6709\u70b9\u95f9\u60c5\u7eea\u2026\u2026\u521a\u521a\u665a\u4e0a\u5c0f\u59e8\u5b50\u6765\u6211\u5bb6\u5403\u996d\uff0c\u7a7f\u4e86\u6761\u9f50x\u5c0f\u77ed\u88d9\u3002\u8001\u5a46\u95ee\u5979\u8fd9\u4e48\u665a\u7a7f\u8fd9\u4e48\u77ed\u7ed9\u8c01\u770b\uff0c\u5c0f\u59e8\u5b50\u4e0d\u5047\u601d\u7d22\u7684\u6765\u4e86\u53e5\u201c\u7ed9\u6211\u59d0\u592b\u770b\u7684\u2026\u2026\u201d\uff0c\u6211\u77ac\u95f4\u5821\u5792\u4e86\uff01\uff01\uff01  ",                              //微博文字内容
         "width": 0,
         "thumbnail_url": "",
         "comments_count": 202,                             //评论次数
         "image_width": 0,
         "image_height": 0,
         "digg_count": 0,
         "height": 0,
         "id": 7489223,
         "favorite_count": 0                               //赞次数
         },...
     ],
     "total_number": 20
 } 
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"CafeCarFirstViewController.connectionDidFinishLoading...");
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view setHidden:YES];
    /*
     机场列表响应 http:// fd.tourbox.me/getAirportList
     */
    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(responseString);
    NSDictionary *responseInfo = [UMSNSStringJson JSONValue:responseString]; 
    NSMutableArray *addedList = [responseInfo objectForKey:@"data"];
    [self performSelectorOnMainThread:@selector(appendTableWith:) withObject:addedList waitUntilDone:NO];
    //[tableView reloadData];
}

-(void)appendTableWith:(NSMutableArray *)data
{
    for (int i=0;i<[data count];i++) {
        [searchDuanZiList addObject:[data objectAtIndex:i]];
    }
    NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:10];
    for (int ind = 0; ind < [data count]; ind++) {
        int row = [searchDuanZiList indexOfObject:[data objectAtIndex:ind]];
        NSIndexPath *newPath =  [NSIndexPath indexPathForRow:row inSection:0];
        [insertIndexPaths addObject:newPath];
    }
    [tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tableView endUpdates];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height + TOP_SECTION_HEIGHT + BOTTOM_SECTION_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchDuanZiList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    NSDictionary *duanZi = [searchDuanZiList objectAtIndex:row];
    
    static NSString *CellIdentifier = @"OffenceCustomCellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
        //微博名
        UILabel *brandNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SECTION_HEIGHT+5, 0, 320 - TOP_SECTION_HEIGHT, TOP_SECTION_HEIGHT)];
        brandNameLabel.textAlignment = UITextAlignmentLeft;
        brandNameLabel.text = [duanZi objectForKey:@"screen_name"];
        brandNameLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        brandNameLabel.textColor = [UIColor blackColor];
        brandNameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:brandNameLabel];
        //发布时间
        UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(TOP_SECTION_HEIGHT+5, 30, 320 - TOP_SECTION_HEIGHT, TOP_SECTION_HEIGHT-30)];
        timestampLabel.textAlignment = UITextAlignmentLeft;
        NSDecimalNumber *number = (NSDecimalNumber *)[duanZi objectForKey:@"timestamp"];
        NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:[number doubleValue]];
        
        NSDateFormatter *dateTimeFormatter=[[NSDateFormatter alloc] init];
        [dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        timestampLabel.text = [dateTimeFormatter stringFromDate:date];   
        timestampLabel.font = [UIFont fontWithName:@"Helvetica" size:10];
        timestampLabel.textColor = [UIColor blackColor];
        timestampLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:timestampLabel];
        
        //微博头像
        UIImageView *brandLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shi.jpeg"]];
        [brandLogoImageView setFrame:CGRectMake(1, 1, TOP_SECTION_HEIGHT, TOP_SECTION_HEIGHT)];        
        [cell.contentView addSubview:brandLogoImageView];
        [brandLogoImageView setImageWithURL:[NSURL URLWithString:[duanZi objectForKey:@"profile_image_url"]] 
                           placeholderImage:[UIImage imageNamed:@"shi.jpeg"]];
        CALayer * layer = [brandLogoImageView layer];  
        [layer setMasksToBounds:YES];  
        [layer setCornerRadius:5.0];  
        [layer setBorderWidth:1.0];  
        [layer setBorderColor:[[UIColor clearColor] CGColor]];  
        
        //微博内容
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.tag = 1;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.highlightedTextColor = [UIColor whiteColor];
        label.numberOfLines = 0;
        label.opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        label.backgroundColor = [UIColor clearColor];
        //[[label layer] setBorderWidth:1.0f];
        //[[label layer] setBorderColor:[NoneAdultAppDelegate getColorFromRed:255 Green:0 Blue:0 Alpha:100]];
        [[label layer] setBackgroundColor:[NoneAdultAppDelegate getColorFromRed:200 Green:200 Blue:200 Alpha:100]];
        [cell.contentView addSubview:label];
    }
    
    //content内容自适应
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, TOP_SECTION_HEIGHT);
    
    label.text = [duanZi objectForKey:@"content"];
    CGRect rect = CGRectInset(cellFrame, 2, 2);
    label.frame = rect;
    [label sizeToFit];
    if (label.frame.size.height > 46) {
        cellFrame.size.height = 50 + label.frame.size.height - 46;
    }
    else {
        cellFrame.size.height = 50;
    }
    
    
    [cell setFrame:cellFrame];
    
    /*

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:OffenceCustomCellIdentifier];
    }
    
    int row = [indexPath row];
   
    NSDictionary *duanZi = [searchDuanZiList objectAtIndex:row];
    [cell.textLabel setText:[duanZi objectForKey:@"content"]];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    [cell.textLabel setNumberOfLines:0];

    [cell.detailTextLabel setText:[duanZi objectForKey:@"screen_name"]];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[duanZi objectForKey:@"profile_image_url"]] 
                   placeholderImage:[UIImage imageNamed:@"shi.jpeg"]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     */
	return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath...");
//    int row = [indexPath row];
//    if (row == [searchVideoList count]) {
//        [MobClick event:@"clickLoadMore" label:[self getFuncNameStr]];
//		UITableViewCell *loadMoreCell=[tableView cellForRowAtIndexPath:indexPath];
//		loadMoreCell.textLabel.text=@"                           加载中...";
//        
//        [self performSelector:@selector(requestBoyResultFromServer) withObject:nil];
//        [tableView deselectRowAtIndexPath:indexPath animated:YES];
//        return;
//    } else {
//        NSDictionary *video = [searchVideoList objectAtIndex:row];
//        MVUSDetailViewController *detailViewController = [[MVUSDetailViewController alloc]initWithNibName:@"MVUSDetailViewController" bundle:nil];
//        detailViewController.title = @"详细信息";
//        detailViewController.videoId = [video objectForKey:@"videoId"];
//        [self.navigationController pushViewController:detailViewController animated:YES];
//        
//    }
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
