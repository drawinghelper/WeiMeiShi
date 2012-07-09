//
//  NoneAdultDetailViewController.h
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoneAdultAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "UMSNSService.h"

#define FONT_SIZE 14.0f
#define TOP_SECTION_HEIGHT 45.0f
#define BOTTOM_SECTION_HEIGHT 30.0f

@interface NoneAdultDetailViewController : UITableViewController<UIActionSheetDelegate, UMSNSDataSendDelegate>{
    NSDictionary *currentDuanZi;
}
@property(nonatomic, retain) NSDictionary *currentDuanZi;

@end
