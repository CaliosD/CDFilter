//
//  CDFilterContainerView.h
//  FilterDemo
//
//  Created by Calios on 2/22/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDFilterContainerView : UIView

@property (nonatomic, strong, readonly) NSArray *resultArray;

- (void)configureContainerViewWithTypeTitles:(NSArray *)titles
                                  typeValues:(NSArray *)values
                                 instruction:(NSString *)instruction
                                 filterArray:(NSArray *)filterArray;


@end
