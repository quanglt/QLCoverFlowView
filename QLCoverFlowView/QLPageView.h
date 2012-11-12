//
//  QLPageView.h
//  SampleTransform
//
//  Created by Quang on 11/10/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface QLPageView : UIView {
    UIImageView *_imageView;
    UIImageView *_reflectionView;
    CGFloat _reflectionHeight;
    CGFloat _reflectionOffset;
}

// init with reuse identifier. the size will be specified by the parent view at display time
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL enableReflection;

@end
