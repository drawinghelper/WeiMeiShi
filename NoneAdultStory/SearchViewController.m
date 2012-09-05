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
    
    [self addBanner];
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
