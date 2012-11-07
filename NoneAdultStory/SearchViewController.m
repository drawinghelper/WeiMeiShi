//
//  SearchViewController.m
//  WeiMeiShi
//
//  Created by 王 攀 on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"菜谱搜索", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"tab_search"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [[NoneAdultAppDelegate sharedAppDelegate] getTitleShadowColor];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [[NoneAdultAppDelegate sharedAppDelegate] getTitleTextColor];
        [label setShadowOffset:CGSizeMake(0, 1.0)];
        
        self.navigationItem.titleView = label;
        label.text = NSLocalizedString(@"菜谱搜索", @"");
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *urlString = [[NSString alloc] initWithString:@"http://m.xiachufang.com/"];
    
    NSURL *url =[NSURL URLWithString:urlString];
    request =[NSURLRequest requestWithURL:url];
    [self.webView setDelegate:self];   
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0, 0, 44, 44);
    [btnBack addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnBackImage = [UIImage imageNamed:@"webview_back.png"];
    [btnBack setImage:btnBackImage forState:UIControlStateNormal];
    
    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHome.frame = CGRectMake(0, 0, 44, 44);
    [btnHome addTarget:self action:@selector(goHomeAction) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnHomeImage = [UIImage imageNamed:@"webview_home.png"];
    [btnHome setImage:btnHomeImage forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnHome];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"]
                                                  forBarMetrics:UIBarMetricsDefault];
    //[self addBanner];
}

- (void)goBackAction {
    [self.webView goBack];
}
- (void)goHomeAction {
    [self.webView loadRequest:request];
}
- (void)addBanner {
    UIButton *btnClear = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btnClear.frame = CGRectMake(0, 480 - 20 - 44 - kBannerHeight, 320, kBannerHeight);
    [btnClear setBackgroundImage:[UIImage imageNamed:@"banner_xiachufang.png"]
                        forState:UIControlStateNormal];
    
    [btnClear addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnClear];
}

- (void)downloadAction {
    NSLog(@"clearAction...");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/us/app/id460979760?mt=8"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadRequest:request];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"webViewDidStartLoad...");
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"努力加载中...";
    [HUD setOpacity:1.0f];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad...");
    [HUD hide:YES afterDelay:0];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"didFailLoadWithError..");
    [HUD hide:YES afterDelay:0];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	HUD = nil;
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
