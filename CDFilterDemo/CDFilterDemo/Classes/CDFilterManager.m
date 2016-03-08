//
//  CDFilterManager.m
//  FilterDemo
//
//  Created by Calios on 2/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterManager.h"
#import "CDFilterConfig.h"
#import "CDFilterTitleView.h"
#import "CDFilterContainerView.h"

@interface CDFilterManager ()<CDFilterTitleViewDelegate>

@property (nonatomic, strong) CDFilterContainerView *containerView;
@property (nonatomic, strong) UIView                *bgView;

@property (nonatomic, strong) NSArray               *typeTitles;// type array of category arrays
@property (nonatomic, strong) NSArray               *typeValues;// value array of category type value arrays
@property (nonatomic, strong) NSString              *instruction;// Instruction for filter label
@property (nonatomic, strong) NSArray               *filterTVArray;// filter tableview data source
@property (nonatomic, strong) NSMutableArray        *selectedMutableIndexes;// mutable array contains selected indexes

@property (nonatomic, assign) CGFloat               filterWidth;
@property (nonatomic, assign) CGFloat               filterHeight;

@property (nonatomic, assign) BOOL                  isOpen;
/**
 *  Whether confirm button is shown. Always opposite to `hasTableView`.
 */
@property (nonatomic, assign) BOOL                  showConfirmBtn;
/**
 *  Whether filter view is fullscreen. Always same with `hasTableView`.
 */
@property (nonatomic, assign) BOOL                  isFilterFullscreen;

@end

@implementation CDFilterManager

- (id)init
{
    self = [super init];
    if (self) {
        _typeTitles    = [NSArray array];
        _typeValues    = [NSArray array];
        _filterTVArray = [NSArray array];
        _selectedMutableIndexes = [NSMutableArray array];
        
        _hasTableView = NO;
        _isFilterFullscreen = _hasTableView;
        _showConfirmBtn = !_hasTableView;
        self.isOpen = NO;
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor darkGrayColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissFilter) name:CDFilterWillDismissNotification object:nil];
    }
    return self;
}

- (void)dismissFilter
{
    if (self.hasTableView) {
        NSInteger index = [[_containerView.resultArray lastObject] integerValue];
        [_titleview updateTitle:[_filterTVArray objectAtIndex:index]];
    }
    
    _titleview.isFilterShown = NO;
    [self hideFilter:_titleview];
    
    if ([self.delegate respondsToSelector:@selector(filterDidDismiss:)]) {
        [self.delegate filterDidDismiss:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)showInView:(UIView *)view
{
    _filterWidth = view.frame.size.width;
    
    NSAssert([self.dataSource respondsToSelector:@selector(categoryTitlesForTypesInFilter:)], @"You missed data source `-categoryTitlesForTypesInFilter:`");
    _typeTitles = [self.dataSource categoryTitlesForTypesInFilter:self];
    NSAssert([self.dataSource respondsToSelector:@selector(categoryValuesForTypesInFilter:)], @"You missed data source `-categoryValuesForTypesInFilter:`");
    _typeValues = [self.dataSource categoryValuesForTypesInFilter:self];

    if (_hasTableView) {
        _filterHeight = view.frame.size.height;
        _instruction = [self.dataSource instructionForTableViewInFilter:self];
        
        NSAssert([self.dataSource respondsToSelector:@selector(arrayForTableViewInFilter:)], @"You missed delegate `-arrayForTableViewInFilter:`");
        _filterTVArray = [self.dataSource arrayForTableViewInFilter:self];
    }
    else{
        _filterHeight = kCDFilterSegmentedControlHeight * _typeTitles.count + kCDFilterSegmentPadding * 3 + kCDFilterSegmentHeight;
        [view addSubview:_bgView];
    }
    _containerView = [[CDFilterContainerView alloc] initWithFrame:CGRectMake(0, 64-_filterHeight, _filterWidth, _filterHeight)];
    [_containerView configureContainerViewWithTypeTitles:_typeTitles
                                              typeValues:_typeValues
                                             instruction:_instruction
                                             filterArray:_filterTVArray];
    [view addSubview:_containerView];
}

- (NSArray *)selectedIndexes
{
    if (self.hasTableView) {
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:_containerView.resultArray];
        NSNumber *last = [resultArray lastObject];
        [resultArray removeLastObject];
        if (_typeValues.count == resultArray.count) {
            [_selectedMutableIndexes removeAllObjects];
            for (int i = 0; i < _typeValues.count; i++) {
                NSInteger index = [resultArray[i] integerValue];
                [_selectedMutableIndexes addObject: _typeValues[i][index]];
            }
            [_selectedMutableIndexes addObject:last];
            
        }
    }
    else{
        if (_typeValues.count == _containerView.resultArray.count) {
            [_selectedMutableIndexes removeAllObjects];
            for (int i = 0; i < _typeValues.count; i++) {
                NSInteger index = [_containerView.resultArray[i] integerValue];
                [_selectedMutableIndexes addObject: _typeValues[i][index]];
            }
        }
    }

    return [_selectedMutableIndexes copy];
}

- (NSString *)conditionString
{
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:_containerView.resultArray];
    NSString *filter = @"条件：";

    if (self.hasTableView) {
        [resultArray removeLastObject];
    }
    if (_typeTitles.count == resultArray.count) {

        NSString *condition = [self pinString:_typeTitles indexes:resultArray];
        
        filter = [filter stringByAppendingString:condition];
    }
    
    return  (![filter hasSuffix:@"："]) ? filter : @"";
}

#pragma mark - Lazy-lazy

- (CDFilterTitleView *)titleview
{
    if (!_titleview) {
        _titleview = [[CDFilterTitleView alloc] initWithFrame:CGRectMake(0, 0, _filterWidth, kCDFilterTableViewRowHeight) andTitle:@"全部"];
        _titleview.delegate = self;
    }
    return _titleview;
}

#pragma mark - CDFilterTitleViewDelegate

- (void)showFilter:(CDFilterTitleView *)titleView
{
    if (self.isOpen) {
        return;
    }
    NSLog(@"show filter");
    
    [titleView.titleImgBtn setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
    _bgView.frame = CGRectMake(0, 0, _filterWidth, [[UIScreen mainScreen] bounds].size.height);
    _bgView.alpha = 0.36;

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.91
          initialSpringVelocity:0.18
                        options:kNilOptions
                     animations:^{
                         _containerView.frame = CGRectMake(0, 64, _filterWidth, _filterHeight);
                     }
                     completion:^(BOOL finished) {
                         self.isOpen = YES;
                     }];
}

- (void)hideFilter:(CDFilterTitleView *)titleView
{
    if (!self.isOpen) {
        return;
    }
    
    NSLog(@"hide filter");

    [titleView.titleImgBtn setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.91
          initialSpringVelocity:0.18
                        options:kNilOptions
                     animations:^{
                         _bgView.alpha = 0;
                         _containerView.frame = CGRectMake(0, 64-_filterHeight, _filterWidth, _filterHeight);
                     }
                     completion:^(BOOL finished) {
                         self.isOpen = NO;
                         _bgView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, _filterWidth, [[UIScreen mainScreen] bounds].size.height);
                     }];
}

#pragma mark - Private

- (NSString *)pinString:(NSArray *)source indexes:(NSArray *)indexes
{
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:source];
    NSMutableArray *indexTmp = [NSMutableArray arrayWithArray:indexes];
    NSString *tmpString = @"";
    for (int i = 0; i < tmp.count; i++) {
        NSInteger index = [indexTmp[i] integerValue];
        
        if (index != 0) {
            if (tmpString.length > 0) {
                tmpString = [tmpString stringByAppendingString:@"+"];
            }
            tmpString = [tmpString stringByAppendingString:tmp[i][index]];
        }
    }
    
    return tmpString;
}

@end
