//
//  QLPageScrollView.h
//  SampleTransform
//
//  Created by Quang on 11/9/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLPageView.h"

@class QLCoverFlowPagesView;

@protocol QLCoverFlowPagesViewDelegate <NSObject>

@optional


@end

// this protocol represent Data Model objects.
@protocol QLCoverFlowPagesViewDataSource <NSObject>

@required

- (NSInteger)pageCoverFlowView:(QLCoverFlowPagesView *)pageCoverFlowView numberOfPagesInSection:(NSInteger)section;
- (UIView *)pageCoverFlowView:(QLCoverFlowPagesView *)pageCoverFlowView viewForPageAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfSectionsInPageView:(QLCoverFlowPagesView *)pageCoverFlowView;              // Default is 1 if not implemented

@end


@interface QLCoverFlowPagesView : UIView <UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *scrollView;
@property (weak, nonatomic) id<QLCoverFlowPagesViewDataSource> dataSource;
@property (nonatomic, assign) BOOL showPageControl;

- (id)dequeueReusablePageViewWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated page view, in lieu of allocating a new one.
- (void)reloadData;

@end


