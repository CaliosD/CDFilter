//
//  CDFilterContainerView.h
//  FilterDemo
//
//  Created by Calios on 2/22/16.
//  Copyright © 2016 Calios. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol CDFilterContainerViewDelegate <NSObject>
//
//- (void)containerViewWillDismissWithValue:(NSDictionary *)dict;
//
//@end
@interface CDFilterContainerView : UIView

@property (nonatomic, strong, readonly) NSArray *resultArray;
//@property (nonatomic, assign) id<CDFilterContainerViewDelegate> delegate;

- (void)configureContainerViewWithTypeTitles:(NSArray *)titles
                                  typeValues:(NSArray *)values
                                 instruction:(NSString *)instruction
                                 filterArray:(NSArray *)filterArray;


@end
