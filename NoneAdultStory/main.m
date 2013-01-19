//
//  main.m
//  NoneAdultStory
//
//  Created by 王 攀 on 12-5-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NoneAdultAppDelegate.h"
#import "AdSageManager.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [[AdSageManager getInstance] setAdSageKey:@"b9d05c2bb7c340b7ac19e435cf72125b"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([NoneAdultAppDelegate class]));
    }
}
