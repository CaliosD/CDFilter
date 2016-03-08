//
//  CDFilterManager.h
//  FilterDemo
//
//  Created by Calios on 2/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDFilterManager;
@class CDFilterTitleView;

@protocol CDFilterDataSource <NSObject>

- (NSArray *)categoryTitlesForTypesInFilter:(CDFilterManager *)filter;
- (NSArray *)categoryValuesForTypesInFilter:(CDFilterManager *)filter;

@optional

- (NSString *)instructionForTableViewInFilter:(CDFilterManager *)filter;
- (NSArray *)arrayForTableViewInFilter:(CDFilterManager *)filter;

@end

@protocol CDFilterDelegate <NSObject>

@optional
- (void)filter:(CDFilterManager *)filter willDismissWithValue:(NSDictionary *)dict;

@end

@interface CDFilterManager : NSObject
/**
 *  是否有筛选列表
 */
@property (nonatomic, assign) BOOL hasTableView;
@property (nonatomic, strong) CDFilterTitleView *titleview;// Added in navigationBar as its titleview.

@property (nonatomic, assign) id<CDFilterDataSource> dataSource;
@property (nonatomic, assign) id<CDFilterDelegate> delegate;

@property (nonatomic, assign, readonly) NSArray *selectedIndexes;
@property (nonatomic, strong, readonly) NSString *conditionString;

- (id)init;
- (void)showInView:(UIView *)view;

@end
