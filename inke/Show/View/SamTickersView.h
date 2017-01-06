//
//  SamTickersView.h
//  inke
//
//  Created by Sam on 12/27/16.
//  Copyright © 2016 Zhejiang University of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SamTickersDelegate <NSObject>

@optional
-(CGSize) sizeForTickersView;
-(NSMutableArray *)tickersDataList;

@end

@interface SamTickersView : UIView

@property(nonatomic, assign) id<SamTickersDelegate> delegate;

@property (nonatomic, assign) BOOL isPageControl;

+ (instancetype) loadTickersView;

- (void)updateForImagesAndLinks:(NSMutableArray *)resourceArray;

- (NSString *)LinkAtCurrentPageIndex;


@end
