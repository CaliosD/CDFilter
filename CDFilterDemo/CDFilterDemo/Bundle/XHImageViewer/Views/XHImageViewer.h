//
//  XHImageViewer.h
//  XHImageViewer
//
//  Created by 曾 宪华 on 14-2-17.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507
//  本人QQ群（142557668）. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHImageURLDataSource.h"

@class XHImageViewer;

typedef void (^WillDismissWithSelectedViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

typedef void (^DidDismissWithSelectedViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

typedef void (^DidChangeToImageViewBlock)(XHImageViewer *imageViewer, UIImageView *selectedView);

@protocol XHImageViewerDelegate <NSObject>

@optional
- (void)imageViewer:(XHImageViewer *)imageViewer
    willDismissWithSelectedView:(UIImageView *)selectedView;
- (void)imageViewer:(XHImageViewer *)imageViewer
    didDismissWithSelectedView:(UIImageView *)selectedView;
- (void)imageViewer:(XHImageViewer *)imageViewer
    didChangeToImageView:(UIImageView *)selectedView;

- (UIView *)customTopToolBarOfImageViewer:(XHImageViewer *)imageViewer;
- (UIView *)customBottomToolBarOfImageViewer:(XHImageViewer *)imageViewer;
@end

@interface XHImageViewer : UIView

@property (nonatomic, weak) id<XHImageViewerDelegate> delegate;

@property (nonatomic, assign) CGFloat backgroundScale;

@property (nonatomic, assign) BOOL disableTouchDismiss;

- (UIImage *)currentImage;

- (void)showWithImageViews:(NSArray *)views
              selectedView:(UIImageView *)selectedView;

- (id)initWithImageViewerWillDismissWithSelectedViewBlock:(WillDismissWithSelectedViewBlock)willDismissWithSelectedViewBlock
                          didDismissWithSelectedViewBlock:(DidDismissWithSelectedViewBlock)didDismissWithSelectedViewBlock
                                didChangeToImageViewBlock:(DidChangeToImageViewBlock)didChangeToImageViewBlock;

@end
