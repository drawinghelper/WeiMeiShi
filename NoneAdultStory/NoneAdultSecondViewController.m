//
//  NoneAdultSecondViewController.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoneAdultSecondViewController.h"

@interface NoneAdultSecondViewController ()

@end

@implementation NoneAdultSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"历史热门", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"historyhot"];
        
        UILabel *label = (UILabel *)self.navigationItem.titleView;
        [label setText:NSLocalizedString(@"历史热门", @"Second")];
    }
    return self;
}
- (void)loadUrl {
    NSString *configContentsource = [[NoneAdultAppDelegate sharedAppDelegate] getConfigContentsource];
    if ([configContentsource isEqualToString:@"0"]) {
        url = [[NSString alloc] initWithString:@"http://211.157.111.244:6090/hot.json?tag=joke&offset=0&count=100"];
    } else if ([configContentsource isEqualToString:@"1"]) {
        url = [[NSString alloc] initWithString:@"http://nh.tourbox.me/hot.json?tag=joke&offset=0&count=100"];
    } else {
        url = [[NSString alloc] initWithString:@"http://i.snssdk.com/essay/1/top/?tag=joke&offset=0&count=100"];
    }
    NSLog(@"loadUrl: %@", url);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    canLoadNew = NO;
    canLoadOld = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
