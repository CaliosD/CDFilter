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

@interface CDFilterManager ()<CDFilterTitleViewDelegate/*,CDFilterContainerViewDelegate*/>

@property (nonatomic, strong) CDFilterContainerView *containerView;

@property (nonatomic, strong) NSArray      *typeTitles;// type array of category arrays
@property (nonatomic, strong) NSArray      *typeValues;// value array of category type value arrays
@property (nonatomic, strong) NSString     *instruction;// Instruction for filter label
@property (nonatomic, strong) NSArray      *filterTVArray;// filter tableview data source
@property (nonatomic, strong) NSMutableArray *selectedMutableIndexes;// mutable array contains selected indexes

@property (nonatomic, assign) CGFloat      filterWidth;
@property (nonatomic, assign) CGFloat      filterHeight;

@property (nonatomic, assign) BOOL         isOpen;
/**
 *  Whether confirm button is shown. Always opposite to `hasTableView`.
 */
@property (nonatomic, assign) BOOL         showConfirmBtn;
/**
 *  Whether filter view is fullscreen. Always same with `hasTableView`.
 */
@property (nonatomic, assign) BOOL         isFilterFullscreen;

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
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public

- (void)showInView:(UIView *)view
{
    _filterWidth = view.frame.size.width;
    
    NSAssert([self.dataSource respondsToSelector:@selector(categoryTitlesForTypesInFilter:)], @"You missed delegate `-categoryTitlesForTypesInFilter:`");
    _typeTitles = [self.dataSource categoryTitlesForTypesInFilter:self];
    
    if (_hasTableView) {
        _filterHeight = view.frame.size.height;
        _instruction = [self.dataSource instructionForTableViewInFilter:self];
        
        NSAssert([self.dataSource respondsToSelector:@selector(arrayForTableViewInFilter:)], @"You missed delegate `-arrayForTableViewInFilter:`");
        _filterTVArray = [self.dataSource arrayForTableViewInFilter:self];
    }
    else{
        _filterHeight = kCDFilterSegmentedControlHeight * _typeTitles.count + kCDFilterSegmentPadding * 2.5 + kCDFilterSegmentHeight;
    }
    
    _containerView = [[CDFilterContainerView alloc] initWithFrame:CGRectMake(0, -_filterHeight, _filterWidth, _filterHeight)];
//    _containerView.delegate = self;
    [_containerView configureContainerViewWithTypeTitles:_typeTitles
                                              typeValues:_typeValues
                                             instruction:_instruction
                                             filterArray:_filterTVArray];
    [view addSubview:_containerView];
}

- (NSArray *)selectedIndexes
{
    _selectedMutableIndexes = [NSMutableArray arrayWithArray:_containerView.resultArray];
    return [_selectedMutableIndexes copy];
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
    NSLog(@"show filter");
    [titleView.titleImgBtn setStyle:kFRDLivelyButtonStyleCaretUp animated:YES];
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.72
          initialSpringVelocity:0.18
                        options:kNilOptions
                     animations:^{
                         _containerView.frame = CGRectMake(0, 0, _filterWidth, _filterHeight);
                     }
                     completion:^(BOOL finished) {
                         self.isOpen = YES;
                     }];
}

- (void)hideFilter:(CDFilterTitleView *)titleView
{
    NSLog(@"hide filter");
    [titleView.titleImgBtn setStyle:kFRDLivelyButtonStyleCaretDown animated:YES];

    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.72
          initialSpringVelocity:0.18
                        options:kNilOptions
                     animations:^{
                         _containerView.frame = CGRectMake(0, -_filterHeight, _filterWidth, _filterHeight);
                     }
                     completion:^(BOOL finished) {
                         self.isOpen = NO;
                     }];
    
//    NSLog(@"<><><>< %@",self.selectedIndexes);
}

//#pragma mark - CDFilterContainerViewDelegate
//
//- (void)containerViewWillDismissWithValue:(NSDictionary *)dict
//{
//    if([self.delegate respondsToSelector:@selector(filter:willDismissWithValue:)]){
//        [self.delegate filter:self willDismissWithValue:dict];
//    }
//    
//    [self hideFilter:_titleview];
//}

@end
