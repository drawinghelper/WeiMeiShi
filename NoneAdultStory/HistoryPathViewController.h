//
//  HistoryPathViewController.h
//  ParseStarterProject
//
//  Created by James Yu on 12/29/11.
//  Copyright (c) 2011 Parse Inc. All rights reserved.
//

#import <Parse/Parse.h>
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "UMSNSService.h"
#import "NoneAdultAppDelegate.h"
#import "AdSageDelegate.h"
#import "AdSageView.h"
#import "MobiSageRecommendSDK.h"
#import "UMTableViewDemo.h"
#import "EmailableCell.h"

#define FONT_SIZE 14.0f
#define TOP_SECTION_HEIGHT 52.0f
#define BOTTOM_SECTION_HEIGHT 34.0f
#define HORIZONTAL_PADDING 16.0f

@interface HistoryPathViewController : PFQueryTableViewController<MBProgressHUDDelegate, UMSNSDataSendDelegate, UIActionSheetDelegate, AdSageDelegate, MobiSageRecommendDelegate> {
    AdSageView *adView;
    MobiSageRecommendView *recmdView;
    MBProgressHUD *HUD;
    PFObject *currentDuanZi;
    
    NSMutableDictionary *collectedIdsDic;
    NSMutableArray *newObjectArray;
    
    UIImage *currentImage;
}

@end
