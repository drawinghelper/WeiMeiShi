//
//  NoneAdultSettingViewController.m
//  NeiHanStory
//
//  Created by 王 攀 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultSettingViewController.h"

@interface NoneAdultSettingViewController ()

@end

@implementation NoneAdultSettingViewController
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"设置", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"setting"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithRed:219.0f/255 green:241.0f/225 blue:241.0f/255 alpha:1];     
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:37.0f/255 green:149.0f/225 blue:149.0f/255 alpha:1];        
        [label setShadowOffset:CGSizeMake(0, 1.0)];
        
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"设置", @"");
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];   
    
    // Do any additional setup after loading the view from its nib.
    currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *versionForReview = [MobClick getConfigParams:@"versionForReview"];

    starCommentVisible = YES;
    if ([currentAppVersion isEqualToString:versionForReview]) {
        starCommentVisible = NO;
    }
    
    if (versionForReview == nil || versionForReview == [NSNull null]  || [versionForReview isEqualToString:@""]) {
        starCommentVisible = NO;
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return starCommentVisible ? 2 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *veryDarkGray = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:1];
    UIColor *veryLightGray = [UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1];
    
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = veryDarkGray;
    headerLabel.shadowColor = veryLightGray;     
    headerLabel.shadowOffset = CGSizeMake(1.0,1.0); 
    headerLabel.textAlignment = UITextAlignmentCenter;
	headerLabel.font = [UIFont systemFontOfSize:16];
    //headerLabel.text = [[NSString alloc]initWithFormat:@"%@ v%@", @"高清热播剧", currentVersionStr];
    NSString *displayNameKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];

    headerLabel.text = [[NSString alloc]initWithFormat:@"%@ v%@", displayNameKey, currentAppVersion];
	
    return headerLabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 55;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //cell.backgroundColor = [UIColor clearColor]; 
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    switch (row) {
        case 0:
            cell.text = starCommentVisible ? @"评五星鼓励我" : @"用着不爽提意见";
            break;
        case 1:
            cell.text = @"用着不爽提意见";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"didSelectRowAtIndexPath...");
	//RootViewController *root = [self.navigationController.viewControllers objectAtIndex:0];
	//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
	NSUInteger row = [indexPath row];
    
	if(row == 0){
        if (starCommentVisible) {
            NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", APPIRATER_APP_ID];  
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        } else {
            [self umengFeedback];
        }
    }else if (row == 1) {
        [self umengFeedback];
	}
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	NSLog(@"...didSelectRowAtIndexPath");
    
}

- (void)umengFeedback {
    //    [MobClick event:@"feedback_click" label:@"列表页"];
    [UMFeedback showFeedback:self withAppkey:@"4fa3232652701556cc00001e"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
