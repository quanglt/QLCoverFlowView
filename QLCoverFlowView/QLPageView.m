//
//  QLPageView.m
//  SampleTransform
//
//  Created by Quang on 11/10/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import "QLPageView.h"

#define kQLPageViewReflectionAlpha 0.5f
#define kQLPageViewReflectionGap 4.0f
#define kQLPageViewReflectionScale 3.0f


@implementation QLPageView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
    }
    return self;
}

- (void)layoutSubviews {
    if (self.enableReflection)
        [self setupReflection];
    
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
    }
    _imageView.image = _image;
}

/*
 Setup reflection animation. Referred by this library: https://github.com/nicklockwood/ReflectionView
 */
- (void)setupReflection;
{
    //create reflection view
    if (!_reflectionView)
    {
        _reflectionView = [[UIImageView alloc] initWithFrame:self.bounds];
        _reflectionView.contentMode = UIViewContentModeScaleToFill;
        _reflectionView.userInteractionEnabled = NO;
        [self addSubview:_reflectionView];
    }
    
    //get reflection bounds
    CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height * kQLPageViewReflectionScale);
    if (size.height > 0.0f && size.width > 0.0f)
    {
        //create gradient mask
        UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
        CGContextRef gradientContext = UIGraphicsGetCurrentContext();
        CGFloat colors[] = {1.0f, 1.0f, 0.0f, 1.0f};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
        CGPoint gradientStartPoint = CGPointMake(0.0f, 0.0f);
        CGPoint gradientEndPoint = CGPointMake(0.0f, size.height);
        CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                    gradientEndPoint, kCGGradientDrawsAfterEndLocation);
        CGImageRef gradientMask = CGBitmapContextCreateImage(gradientContext);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        UIGraphicsEndImageContext();
        
        //create drawing context
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -self.bounds.size.height);
        
        //clip to gradient
        CGContextClipToMask(context, CGRectMake(0.0f, self.bounds.size.height - size.height,
                                                size.width, size.height), gradientMask);
        CGImageRelease(gradientMask);
        
        //draw reflected layer content
        [self.layer renderInContext:context];
        
        //capture resultant image
        _reflectionView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //update reflection
    _reflectionView.alpha = kQLPageViewReflectionAlpha;
    _reflectionView.frame = CGRectMake(0, self.bounds.size.height + kQLPageViewReflectionGap, size.width, size.height);}

- (void)setEnableReflection:(BOOL)enableReflection {
    _enableReflection = enableReflection;
    self.clipsToBounds = NO;
    [self layoutIfNeeded];
}

@end
