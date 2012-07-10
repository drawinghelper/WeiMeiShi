//
//  NoneAdultFirstViewController.h
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
#import "AdMoGoView.h"
#import "NoneAdultDetailViewController.h"
#import "NSString+HTML.h"

#define FONT_SIZE 14.0f
#define TOP_SECTION_HEIGHT 52.0f
#define BOTTOM_SECTION_HEIGHT 34.0f

@interface NoneAdultFirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, UIActionSheetDelegate, UMSNSDataSendDelegate, MBProgressHUDDelegate, AdMoGoDelegate> {
    AdMoGoView *adView;

    MBProgressHUD *HUD;

    IBOutlet UITableView *tableView;

    NSMutableData *responseData;   
    NSString *url;
    NSMutableArray *searchDuanZiList;
    NSDictionary *currentDuanZi;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    UIActivityIndicatorView *activityIndicator;
    
    //  Reloading var should really be your tableviews datasource
    //  Putting it here for demo purposes
    BOOL canLoadOld;
    BOOL canLoadNew;
    BOOL loadOld;
    BOOL _reloading;
    
    NSDictionary *tempPropertyDic;
    NSMutableArray *originalNewDuanZiList;
}
@property(nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) AdMoGoView *adView;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)goShare:(id)sender;
- (void)performRefresh;
@end
