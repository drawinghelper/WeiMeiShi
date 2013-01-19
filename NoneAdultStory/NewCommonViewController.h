//
//  NewCommonViewController.h
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSNSStringJson.h"
#import "NoneAdultAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "AdSageDelegate.h" 
#import "AdSageView.h"
#import "NoneAdultDetailViewController.h"
#import "NSString+HTML.h"
#import "UMTableViewDemo.h"
#import "EmailableCell.h"

#define FONT_SIZE 14.0f
#define TOP_SECTION_HEIGHT 52.0f
#define BOTTOM_SECTION_HEIGHT 34.0f
#define HORIZONTAL_PADDING 16.0f

@interface NewCommonViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UMSNSDataSendDelegate, MBProgressHUDDelegate, AdSageDelegate> {
    AdSageView *adView;
    MBProgressHUD *HUD;

    IBOutlet UITableView *tableView;

    NSMutableData *responseData;   
    NSString *url;
    NSMutableArray *searchDuanZiList;
    NSMutableDictionary *currentDuanZi;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIActivityIndicatorView *activityIndicator;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL canLoadOld;
    BOOL canLoadNew;
    BOOL loadOld;
    BOOL _reloading;
    
    NSDictionary *tempPropertyDic;
    
    NSMutableDictionary *collectedIdsDic;
    NSMutableDictionary *dingIdsDic;
    
    NSDictionary *pullmessageInfo;
    NSString *currentCid;
    
    UIImage *currentImage;
    BOOL isInCommonView;
}
@property(nonatomic, retain) UITableView *tableView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)goShare:(id)sender;
- (void)goCollect:(id)sender;
- (void)performRefresh;
- (CGRect)getImageDisplayRect:(NSDictionary *)duanZi;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTitle:(NSString *)title withCid:(NSString *)cid;
@end
