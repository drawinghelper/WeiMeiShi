//
//  NoneAdultSettingViewController.h
//  NeiHanStory
//
//  Created by 王 攀 on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "UMFeedback.h"
#import "Appirater.h"
#import "NoneAdultAppDelegate.h"
@interface NoneAdultSettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    IBOutlet UITableView *tableView;
    
    NSString *versionForReview;
    NSString *currentAppVersion;
    BOOL starCommentVisible;
}
@property(nonatomic, retain) UITableView *tableView;

@end
