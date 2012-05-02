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
#define FONT_SIZE 14.0f
#define TOP_SECTION_HEIGHT 45.0f
#define BOTTOM_SECTION_HEIGHT 30.0f

@interface NoneAdultFirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tableView;

    NSMutableData *responseData;   
    NSString *url;
    NSMutableArray *searchDuanZiList;
    
}
@property(nonatomic, retain) UITableView *tableView;


@end
