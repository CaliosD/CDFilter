//
//  CDFilterCategoryItem.m
//  FilterDemo
//
//  Created by Calios on 2/26/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import "CDFilterCategoryItem.h"

@implementation CDFilterCategoryItem

- (id)initWithWithCategoryName:(NSString *)name value:(NSInteger)value
{
    self = [super init];
    if (self) {
        _categoryName = name;
        _categoryValue = value;
    }
    return self;
}


@end
