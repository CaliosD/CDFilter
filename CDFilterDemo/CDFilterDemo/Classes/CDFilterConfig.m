//
//  CDFilterConfig.m
//  FilterDemo
//
//  Created by Calios on 2/25/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterConfig.h"

NSString *const CDFilterWillDismissNotification = @"CDFilterWillDismissNotification";

@implementation CDFilterConfig

+ (UIColor *)filterThemeColor
{
    return [UIColor colorWithRed:201/255.0 green:33/255.0 blue:29/255.0 alpha:1.0];
}

+ (UIColor *)seperatorColor
{
    return [UIColor colorWithWhite:0.810 alpha:1.000];
}

@end
