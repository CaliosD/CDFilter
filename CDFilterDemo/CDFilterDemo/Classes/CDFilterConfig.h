//
//  CDFilterConfig.h
//  FilterDemo
//
//  Created by Calios on 2/25/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

static CGFloat kCDFilterTitleFontSize          = 18.f;
static CGFloat kCDFilterTitleHeight            = 44.f;
static CGFloat kCDFilterImgBtnSize             = 20.f;

static NSInteger kCDFilterSegmentTagSalt       = 10086;
static CGFloat kCDFilterSegmentPadding         = 12.f;
static CGFloat kCDFilterSegmentedControlHeight = 40.f;
static CGFloat kCDFilterSegmentWidth           = 80.f;
static CGFloat kCDFilterSegmentHeight          = 30.f;

static CGFloat kCDFilterInfoLabelFontSize      = 12.f;
static CGFloat kCDFilterTableViewRowHeight     = 44.f;
static CGFloat kCDFilterTableViewCellFontSize  = 15.f;
static CGFloat kCDFilterSeperatorLineHeight    = 0.5f;

extern NSString *const CDFilterWillDismissNotification;

@interface CDFilterConfig : NSObject

+ (UIColor *)filterThemeColor;
+ (UIColor *)seperatorColor;

@end
