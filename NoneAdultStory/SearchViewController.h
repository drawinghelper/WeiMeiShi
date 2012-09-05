//
//  SearchViewController.h
//  WeiMeiShi
//
//  Created by 王 攀 on 12-8-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define kBannerHeight 45
@interface SearchViewController : UIViewController<UIWebViewDelegate, MBProgressHUDDelegate> {
    IBOutlet UIWebView *webView;
    MBProgressHUD *HUD;
    NSURLRequest *request;
}
@property (strong, nonatomic) UIWebView *webView;

@end
