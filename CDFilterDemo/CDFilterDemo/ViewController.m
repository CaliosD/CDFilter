//
//  ViewController.m
//  CDFilterDemo
//
//  Created by Calios on 3/7/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "ViewController.h"
#import "CDFilter.h"

@interface ViewController ()<CDFilterDataSource>

@property (nonatomic, strong) CDFilterManager *filter;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Test";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = kCDFilterThemeColor;
    
    _filter = [[CDFilterManager alloc] init];
    _filter.dataSource = self;
    //    _filter.hasTableView = NO;
    _filter.hasTableView = YES;
    
    [_filter showInView:self.view];
    
    self.navigationItem.titleView = _filter.titleview;
    //    [self.navigationController.navigationBar layoutIfNeeded];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithTitle:@"post" style:UIBarButtonItemStyleDone target:self action:@selector(postFilter)];
    post.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = post;
}

- (void)postFilter
{
    NSLog(@"<><><><>< %@",_filter.selectedIndexes);
}

/*
 - (NSArray *)typesArray
 {
 NSMutableArray *types = [NSMutableArray array];
 
 NSArray *k1 = @[@"全部",@"待开课",@"授课中",@"已结束"];
 NSArray *v1 = @[
 NSNumberFromEnum(CourseStatus_All),
 NSNumberFromEnum(CourseStatus_PrepareStart),
 NSNumberFromEnum(CourseStatus_InProcess),
 NSNumberFromEnum(CourseStatus_Finished)
 ];
 NSMutableArray *t1 = [NSMutableArray array];
 NSAssert(k1.count == v1.count, @"There're missing key or value for segment1.");
 for (int i = 0; i < k1.count; i++) {
 CDFilterCategoryItem *item = [[CDFilterCategoryItem alloc] initWithWithCategoryName:k1[i] value:[v1[i] integerValue]];
 [t1 addObject:item];
 }
 
 NSArray *k2 = @[@"全部",@"必修",@"选修"];
 NSArray *v2 = @[
 NSNumberFromEnum(CourseType_All),
 NSNumberFromEnum(CourseType_Required),
 NSNumberFromEnum(CourseType_Elective)
 ];
 NSMutableArray *t2 = [NSMutableArray array];
 NSAssert(k2.count == v2.count, @"There're missing key or value for segment2.");
 for (int i = 0; i < k2.count; i++) {
 CDFilterCategoryItem *item = [[CDFilterCategoryItem alloc] initWithWithCategoryName:k2[i] value:[v2[i] integerValue]];
 [t2 addObject:item];
 }
 
 [types addObject:t1];
 [types addObject:t2];
 return types;
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CDFilterDataSource

// I wonder if the return value should be an array of array or an array of dictionaries.(Calios:0223)
// Now I wonder if data source should be seperate array of titles and values or array of conbined object.(Calios: 0228)
- (NSArray *)categoryTitlesForTypesInFilter:(CDFilterManager *)filter
{
    return @[
             @[@"全部",@"待开课",@"授课中",@"已结束"],
             @[@"全部",@"必修",@"选修"]
             ];
}

- (NSArray *)categoryValuesForTypesInFilter:(CDFilterManager *)filter
{
    return @[
             @[
                 NSNumberFromEnum(CourseStatus_All),
                 NSNumberFromEnum(CourseStatus_PrepareStart),
                 NSNumberFromEnum(CourseStatus_InProcess),
                 NSNumberFromEnum(CourseStatus_Finished)
                 ],
             @[
                 NSNumberFromEnum(CourseType_All),
                 NSNumberFromEnum(CourseType_Required),
                 NSNumberFromEnum(CourseType_Elective)
                 ]
             ];
}

- (NSString *)instructionForTableViewInFilter:(CDFilterManager *)filter
{
    return @"请选择课程分类";
}

- (NSArray *)arrayForTableViewInFilter:(CDFilterManager *)filter
{
    return @[@"all",@"cell0",@"cell1",@"cell2",@"cell3",@"cell4"];
}

@end
