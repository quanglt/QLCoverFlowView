//
//  QLPageView.m
//  SampleTransform
//
//  Created by Quang on 11/10/12.
//  Copyright (c) 2012 Quang. All rights reserved.
//

#import "QLPageView.h"

#define kQLPageViewReflectionAlpha 0.5f
#define kQLPageViewReflectionOffset 2.0f
#define kQLPageViewReflectionHeight 60.0f

@implementation QLPageView

- (void)setup;
{
    _reflectionView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _reflectionView.alpha = kQLPageViewReflectionAlpha;
    _reflectionHeight = kQLPageViewReflectionHeight;
    _reflectionOffset = kQLPageViewReflectionOffset;
    [self addSubview:_reflectionView];
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = [reuseIdentifier copy];
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_enableReflection) {
        CGRect reflectionFrame = self.bounds;
        reflectionFrame.origin.y += reflectionFrame.size.height + _reflectionOffset;
        reflectionFrame.size.height = _reflectionHeight;
        _reflectionView.frame = reflectionFrame;
        [self updateReflection];
    }
    
}

- (void)setImage:(UIImage *)image reflected:(BOOL)reflected {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_imageView];
    }
    _imageView.image = image;
    _enableReflection = reflected;
    if (_enableReflection) {
        [self updateReflection];
    } else {
        _reflectionView.hidden = YES;
    }
}

#pragma mark - reflection section
/*
 create reflected animation. Referring the document: http://aptogo.co.uk/2011/08/no-fuss-reflections/
 */
- (void)updateReflection
{
    _reflectionView.image = [self reflectedImage];
}

// Creates an autoreleased reflected image of the contents of the main view
- (UIImage *)reflectedImage
{
    // Calculate the size of the reflection in devices units - supports hires displays
    CGFloat displayScale = 1.0f;
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        displayScale = [[UIScreen mainScreen] scale];
    }
    
    CGSize deviceReflectionSize = _reflectionView.bounds.size;
    deviceReflectionSize.width *= displayScale;
    deviceReflectionSize.height *= displayScale;
    
    // Create the bitmap context to draw into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             deviceReflectionSize.width,
                                             deviceReflectionSize.height,
                                             8,
                                             0,
                                             colorSpace,
                                             // Optimal BGRA format for the device:
                                             (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    CGColorSpaceRelease(colorSpace);
    
    if (!ctx)
    {
        return nil;
    }
    
    // Create a 1 pixel-wide gradient (will be stretched by CGContextClipToMask)
    CGImageRef gradientImage = CreateGradientImage(1, deviceReflectionSize.height);
    
	// Use the gradient image as a mask
    CGContextClipToMask(ctx, CGRectMake(0.0f, 0.0f, deviceReflectionSize.width, deviceReflectionSize.height), gradientImage);
    CGImageRelease(gradientImage);
    
    // Translate origin to position reflection correctly. Reflection will be flipped automatically because of differences between
    // Quartz2D coordinate system and CALayer coordinate system.
	CGContextTranslateCTM(ctx, 0.0, -self.bounds.size.height * displayScale + deviceReflectionSize.height);
    CGContextScaleCTM(ctx, displayScale, displayScale);
    
    // Render into the reflection context. Rendering is wrapped in a transparency layer otherwise sublayers
    // will be rendered individually using the gradient mask and hidden layers will show through
	CGContextBeginTransparencyLayer(ctx, NULL);
    [self.layer renderInContext:ctx];
    CGContextEndTransparencyLayer(ctx);
    
    // Create the reflection image from the context
	CGImageRef reflectionCGImage = CGBitmapContextCreateImage(ctx);
    UIImage *reflectionImage = [UIImage imageWithCGImage:reflectionCGImage];
	CGContextRelease(ctx);
	CGImageRelease(reflectionCGImage);
    
	return reflectionImage;
}


// Creates a vertical grayscale gradient of the specified size and returns a CGImage
CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
    CGImageRef theCGImage = NULL;
    
    // Create a grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create the bitmap context to draw into
    CGContextRef gradientContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Define start and end color stops (alpha values required even though not used in the gradient)
    CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
    CGPoint gradientStartPoint = CGPointZero;
    CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
    
    // Draw the gradient
    CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
    CGContextDrawLinearGradient(gradientContext,
                                grayScaleGradient,
                                gradientStartPoint,
                                gradientEndPoint,
                                kCGGradientDrawsAfterEndLocation);
    
    // Create the image from the context
    theCGImage = CGBitmapContextCreateImage(gradientContext);
    
    // Clean up
    CGGradientRelease(grayScaleGradient);
    CGContextRelease(gradientContext);
    CGColorSpaceRelease(colorSpace);
    
    // Return the CGImageRef containing the gradient (with refcount = 1)
    return theCGImage;
}

@end
