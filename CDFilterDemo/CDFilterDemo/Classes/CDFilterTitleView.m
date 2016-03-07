//
//  CDFilterTitleView.m
//  FilterDemo
//
//  Created by Calios on 2/22/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterTitleView.h"
#import "CDFilterConfig.h"

@interface CDFilterTitleView ()

@property (nonatomic, strong) UIButton        *titleBtn;
@property (nonatomic, strong) NSString        *titleString;

@end

@implementation CDFilterTitleView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isFilterShown = NO;
        _titleString = title;
        _titleBtn = [[UIButton alloc] init];
        _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _titleBtn.titleLabel.font = [UIFont systemFontOfSize:kCDFilterTitleFontSize];
        [_titleBtn setTitle:_titleString forState:UIControlStateNormal];
        [_titleBtn addTarget:self action:@selector(titleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        _titleImgBtn = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_titleImgBtn setStyle:kFRDLivelyButtonStyleCaretDown animated:NO];
        [_titleImgBtn addTarget:self action:@selector(titleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [_titleImgBtn setOptions:@{kFRDLivelyButtonLineWidth : @(1.f), kFRDLivelyButtonHighlightedColor : [UIColor whiteColor], kFRDLivelyButtonColor : [UIColor whiteColor]}];
        
        [self addSubview:_titleBtn];
        [self addSubview:_titleImgBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    CGFloat width = [_titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kCDFilterTitleFontSize]}].width;
    CGFloat x = (self.frame.size.width - width - kCDFilterImgBtnSize)/2.f;
    _titleBtn.frame = CGRectMake(x, 0, width, kCDFilterTitleHeight);
    _titleImgBtn.frame = CGRectMake(x + width + 5, 12, kCDFilterImgBtnSize, kCDFilterImgBtnSize);
    [_titleImgBtn setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];
}

- (void)titleBtnPressed
{
    self.isFilterShown = !self.isFilterShown;
    if (self.isFilterShown) {
        if ([self.delegate respondsToSelector:@selector(showFilter:)]) {
            [self.delegate showFilter:self];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(hideFilter:)]) {
            [self.delegate hideFilter:self];
        }
    }
}

- (void)updateTitle:(NSString *)title
{
    self.isFilterShown = NO;
    [self.titleImgBtn setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];
    _titleString = title;
    [self layoutSubviews];
    [_titleBtn setTitle:title forState:UIControlStateNormal];
}

@end
