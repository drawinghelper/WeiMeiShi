//
//  UIView+Gradient.m
//  WeiKanShiJie
//
//  Created by 王 攀 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+Gradient.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Gradient)
-(void) addLinearUniformGradient:(NSArray *)stopColors
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = stopColors;
    gradient.startPoint = CGPointMake(0.5f, 0.0f);
    gradient.endPoint = CGPointMake(0.5f, 1.0f);    
    [self.layer addSublayer:gradient];
}
@end
