//
//  CDFilterCategoryItem.h
//  FilterDemo
//
//  Created by Calios on 2/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDFilterCategoryItem : NSObject

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, assign) NSInteger categoryValue;

- (id)initWithWithCategoryName:(NSString *)name value:(NSInteger)value;

@end
