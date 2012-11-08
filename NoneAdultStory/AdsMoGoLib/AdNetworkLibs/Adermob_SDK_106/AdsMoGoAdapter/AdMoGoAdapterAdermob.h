//
//  AdMoGoAdapterAdermob.h
//  AdsMogo 1.2.1   
//
//  Created by pengxu on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  ader v1.0.5

#import "AdMoGoAdNetworkAdapter.h"
#import "AderDelegateProtocal.h"
#import "AderSDK.h"

@interface AdMoGoAdapterAdermob : AdMoGoAdNetworkAdapter <AderDelegateProtocal>{
    BOOL isStop;
}

+ (AdMoGoAdNetworkType)networkType;
@end
