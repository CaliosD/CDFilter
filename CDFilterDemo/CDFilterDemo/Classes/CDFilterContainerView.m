
//  CDFilterContainerView.m
//  FilterDemo
//
//  Created by Calios on 2/22/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterContainerView.h"
#import "NYSegmentedControl.h"
#import "CDFilterConfig.h"

static NSString *kCDFilterTVCellIdentifier = @"CDFilterTVCellIdentifier";

typedef NYSegmentedControl *(^CreateSegmentedControl)(NSArray *);

@interface CDFilterContainerView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) CreateSegmentedControl createSegment;
@property (nonatomic, strong) UITableView            *filterTV;
@property (nonatomic, strong) UILabel                *infoLabel;
@property (nonatomic, strong) UIView                 *seperateLine;
@property (nonatomic, strong) UIButton               *confirmBtn;

@property (nonatomic, strong) NSArray                *typeTitles;// type array of category arrays
@property (nonatomic, strong) NSArray                *typeValues;// value array of category type value arrays
@property (nonatomic, strong) NSString               *instruction;// Instruction for filter label
@property (nonatomic, strong) NSArray                *filterTVArray;// filter tableview data source
@property (nonatomic, strong) NSMutableArray         *segments;
@property (nonatomic, strong) NSMutableArray         *resultMutableArray;

@property (nonatomic, assign) NSInteger              selectedTVIndex;

@end

@implementation CDFilterContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _typeTitles          = [NSArray array];
        _typeValues          = [NSArray array];
        _filterTVArray       = [NSArray array];
        _segments            = [NSMutableArray array];
        _selectedTVIndex     = 0;
        _resultMutableArray  = [NSMutableArray array];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor whiteColor];
        _infoLabel.textColor = [CDFilterConfig filterThemeColor];
        _infoLabel.font = [UIFont systemFontOfSize:kCDFilterInfoLabelFontSize];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_infoLabel];
        _infoLabel.hidden = YES;
        
        _seperateLine = [[UIView alloc] initWithFrame:CGRectZero];
        _seperateLine.backgroundColor = [CDFilterConfig seperatorColor];
        [self addSubview:_seperateLine];
        _seperateLine.hidden = YES;
        
        _filterTV            = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _filterTV.delegate   = self;
        _filterTV.dataSource = self;
        _filterTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_filterTV];
        _filterTV.hidden = YES;
        
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_confirmBtn setBackgroundColor:[CDFilterConfig filterThemeColor]];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 7.f;
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_confirmBtn];
        _confirmBtn.hidden = YES;
        
        __weak CDFilterContainerView *weakSelf = self;
        _createSegment = ^(NSArray *arr){
            NYSegmentedControl *segmentedControl = [[NYSegmentedControl alloc] initWithItems:arr];
            segmentedControl.titleTextColor = [CDFilterConfig filterThemeColor];
            segmentedControl.selectedTitleTextColor = [UIColor whiteColor];
            segmentedControl.segmentIndicatorBackgroundColor = [CDFilterConfig filterThemeColor];
            segmentedControl.backgroundColor = [UIColor clearColor];
            segmentedControl.borderWidth = 0;
            segmentedControl.borderColor = [CDFilterConfig filterThemeColor];
            segmentedControl.segmentIndicatorBorderWidth = 0.0f;
            segmentedControl.segmentIndicatorInset = 2.0f;
            segmentedControl.segmentIndicatorBorderColor = weakSelf.backgroundColor;
            segmentedControl.segmentedControlSize = CGSizeMake(kCDFilterSegmentWidth, kCDFilterSegmentHeight);
            segmentedControl.titleFont = [UIFont systemFontOfSize:kCDFilterInfoLabelFontSize];
            [segmentedControl sizeToFit];
            segmentedControl.cornerRadius = 7.f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
            segmentedControl.usesSpringAnimations = YES;
#endif
            [weakSelf addSubview:segmentedControl];
            return segmentedControl;
        };
    }
    return self;
}

- (void)confirmBtnPressed
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CDFilterWillDismissNotification object:nil];
}

#pragma mark - Public

- (void)configureContainerViewWithTypeTitles:(NSArray *)titles
                                  typeValues:(NSArray *)values
                                 instruction:(NSString *)instruction
                                 filterArray:(NSArray *)filterArray
{
    _typeTitles = titles;
    _typeValues = values;
    _filterTVArray = filterArray;
    
    [_segments removeAllObjects];  // ?? How to handle the subviews added to weakSelf?
    
    for (int i = 0 ; i < _typeTitles.count; i++) {
        NYSegmentedControl *control = _createSegment(_typeTitles[i]);
        control.tag = kCDFilterSegmentTagSalt + i;
        control.frame = CGRectMake(kCDFilterSegmentPadding, kCDFilterSegmentPadding * (i + 1) + kCDFilterSegmentHeight * i, kCDFilterSegmentWidth * [_typeTitles[i] count], kCDFilterSegmentHeight);
        [_segments addObject:control];
    }
    
    CGFloat y = kCDFilterSegmentPadding * (_typeTitles.count + 1) + kCDFilterSegmentHeight * _typeTitles.count;
    if (instruction && instruction.length > 0) {
        _infoLabel.hidden = NO;
        _seperateLine.hidden = NO;

        _infoLabel.frame = CGRectMake(0, y, self.frame.size.width, kCDFilterInfoLabelFontSize + kCDFilterSegmentPadding);
        y += kCDFilterSegmentPadding + kCDFilterInfoLabelFontSize;
        _infoLabel.text = instruction;
        
        y += kCDFilterSegmentPadding;
        _seperateLine.frame = CGRectMake(0, y, self.frame.size.width, kCDFilterSeperatorLineHeight);
        y += kCDFilterSeperatorLineHeight * 2;
    }
    
    if (filterArray && filterArray.count > 0) {
        
        _filterTV.hidden = NO;
        _filterTV.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height - y);

        [_filterTV reloadData];
    }
    else{
        _confirmBtn.hidden = NO;
        _confirmBtn.frame = CGRectMake((self.frame.size.width - 180)/2.f, CGRectGetMaxY([[_segments lastObject] frame]) + kCDFilterSegmentPadding * 1.5, 180, kCDFilterSegmentHeight);
    }
}

- (NSArray *)resultArray
{
    if (_segments.count > 0) {
        [_resultMutableArray removeAllObjects];
        for (int i = 0; i < _segments.count; i++) {
            [_resultMutableArray addObject:[NSNumber numberWithInteger:[_segments[i] selectedSegmentIndex]]];
        }
    }
    if (_filterTVArray.count > 0) {
        [_resultMutableArray addObject:[NSNumber numberWithInteger:_selectedTVIndex]];
    }
    
    return [_resultMutableArray copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _filterTVArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCDFilterTVCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCDFilterTVCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:kCDFilterTableViewCellFontSize];
    cell.textLabel.text = _filterTVArray[indexPath.row];
    cell.accessoryType = (indexPath.row == _selectedTVIndex) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *prevIndex = [NSIndexPath indexPathForItem:_selectedTVIndex inSection:0];
    _selectedTVIndex = indexPath.row;
    if (![indexPath isEqual: prevIndex]) {
        [tableView reloadRowsAtIndexPaths:@[indexPath,prevIndex] withRowAnimation:UITableViewRowAnimationNone];
        [[NSNotificationCenter defaultCenter] postNotificationName:CDFilterWillDismissNotification object:nil];
    }
}

@end
