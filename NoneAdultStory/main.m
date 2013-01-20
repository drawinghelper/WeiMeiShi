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
        [[AdSageManager getInstance] setAdSageKey:@"de5c646025f2451dbf5cea46eb66ac07"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([NoneAdultAppDelegate class]));
    }
}
