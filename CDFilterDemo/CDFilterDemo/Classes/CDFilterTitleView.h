//
//  CDFilterTitleView.h
//  FilterDemo
//
//  Created by Calios on 2/22/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRDLivelyButton.h"

@class CDFilterTitleView;

@protocol CDFilterTitleViewDelegate <NSObject>

- (void)showFilter:(CDFilterTitleView *)titleView;
- (void)hideFilter:(CDFilterTitleView *)titleView;

@end
@interface CDFilterTitleView : UIView

@property (nonatomic, strong) FRDLivelyButton *titleImgBtn;
@property (nonatomic, assign) BOOL            isFilterShown;
@property (nonatomic, assign) id<CDFilterTitleViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;
- (void)updateTitle:(NSString *)title;

@end
