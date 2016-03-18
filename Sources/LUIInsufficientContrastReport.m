//
//  LUIInsufficientContrastReport.m
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIInsufficientContrastReport.h"

static CGFloat LUIMinimumContrast = .2;

@interface LUIInsufficientContrastReport ()

@property (strong, nonatomic) UIView* view;
@property (strong, nonatomic) UIView* backgroundView;

@end

typedef struct {
    CGFloat min;
    CGFloat max;
} LuminanceRange;

typedef struct
{
    Byte red;
    Byte green;
    Byte blue;
    Byte alpha;

} RGBAPixel;

CGFloat LUILuminanceForPixel(RGBAPixel pixel) {
    return (pixel.red * .2126 + pixel.green * 0.7152 + pixel.blue * 0.0722) / 255;
}

CGFloat LUILuminanceForColor(UIColor* color) {
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:NULL];
    RGBAPixel pixel = {.red = (Byte)(r * 255), .green = (Byte)(g * 255), .blue = (Byte)(b * 255), .alpha = 1};
    return LUILuminanceForPixel(pixel);
}

LuminanceRange LUILuminanceForImage(UIImage* image) {
    CGImageRef imageRep = image.CGImage;
    NSInteger width = CGImageGetWidth(imageRep);
    NSInteger height = CGImageGetHeight(imageRep);

    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, cs, kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, image.CGImage);
    CGColorSpaceRelease(cs);

    CGFloat min = 1;
    CGFloat max = 0;
    
    const RGBAPixel* pixels = (const RGBAPixel*)CGBitmapContextGetData(bmContext);
    for (NSUInteger y = 0; y < height; y++)
    {
        for (NSUInteger x = 0; x < width; x++)
        {
            const NSUInteger index = x + y * width;
            RGBAPixel pixel = pixels[index];

            min = MIN(LUILuminanceForPixel(pixel), min);
            max = MAX(LUILuminanceForPixel(pixel), max);
        }
    }
    CGContextRelease(bmContext);

    LuminanceRange range = {.min = min, .max = max};
    return range;
}

BOOL LUILuminanceLacksContrast(CGFloat foregroundLuminance, CGFloat backgroundLuminance) {
    return fabs(foregroundLuminance - backgroundLuminance) < LUIMinimumContrast;
}

@interface UIColor (LUIColorHelpers)

@end

@implementation UIColor (LUIColorHelpers)

- (UIColor*)lui_colorIgnoringClear {
    CGFloat alpha;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    if(alpha < 0.00001) {
        return nil;
    }
    return self;
}

@end

@implementation LUIInsufficientContrastReport

+ (NSString*)identifier {
    return @"insufficient-contrast";
}

+ (NSArray<NSNumber*>*)foregroundLuminanceForView:(UIView*)view {
    if([view isKindOfClass:[UILabel class]]) {
        UILabel* label = (UILabel*)view;
        if([label.superview isKindOfClass:[UIButton class]]) {
            // May be button's titleLabel. titleColor isn't always the current color, so use that
            UIButton* containingButton = (UIButton*)label.superview;
            UIColor* titleColor = [containingButton titleColorForState:UIControlStateNormal];
            if(containingButton.titleLabel == view && titleColor && !label.attributedText) {
                return @[@(LUILuminanceForColor(titleColor))];
            }
        }

        NSMutableSet* result = [[NSMutableSet alloc] init];
        for(NSUInteger i = 0; i < label.text.length; i++) {
            UIColor* color = [label.attributedText attribute:NSForegroundColorAttributeName atIndex:i effectiveRange:NULL] ?: label.textColor ?: label.tintColor ?: [UIColor blackColor]; // black is the default
            [result addObject:@(LUILuminanceForColor(color))];
        }
        return result.allObjects;
    }
    else if([view isKindOfClass:[UIImageView class]]) {
        UIImageView* imageView = (UIImageView*)view;
        if(imageView.image.renderingMode == UIImageRenderingModeAlwaysTemplate && imageView.tintColor != nil) {
            return @[@(LUILuminanceForColor(imageView.tintColor))];
        }
    }
    return @[];
}

- (id)initWithView:(UIView*)view backgroundView:(UIView*)backgroundView {
    self = [super init];
    if(self != nil) {
        self.view = view;
        self.backgroundView = backgroundView;
    }
    return self;
}

- (NSString*)message {
    return [NSString stringWithFormat: @"View %@ has insufficient contrast with its background view: %@", self.view, self.backgroundView];
}

+ (NSArray<NSNumber*>*)backgroundLuminositiesOfView:(UIView*)view {
    if([view isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)view;
        UIImage* backgroundImage = [button backgroundImageForState:UIControlStateNormal];
        if(backgroundImage) {
            LuminanceRange range = LUILuminanceForImage(backgroundImage);
            return @[@(range.min), @(range.max)];
        }
    }

    UIColor* color = [view.backgroundColor lui_colorIgnoringClear];
    if(color) {
        return @[@(LUILuminanceForColor(color))];
    }

    return @[];
}

+ (NSArray<id<LUIReport>>*)reports:(UIView *)view {
    UIView* nearestBackgroundView = view;
    NSArray<NSNumber*>* nearestBackgroundLuminosities = nil;
    while(nearestBackgroundView != nil && nearestBackgroundLuminosities.count == 0) {
        nearestBackgroundLuminosities = [self backgroundLuminositiesOfView:nearestBackgroundView];
        if(nearestBackgroundLuminosities.count == 0) {
            nearestBackgroundView = nearestBackgroundView.superview;
        }
    }

    NSArray<NSNumber*>* foregrounds = [self foregroundLuminanceForView:view];
    for(NSNumber* foreground in foregrounds) {
        for(NSNumber* background in nearestBackgroundLuminosities) {
            if(LUILuminanceLacksContrast(foreground.floatValue, background.floatValue)) {
                return @[[[LUIInsufficientContrastReport alloc] initWithView:view backgroundView:nearestBackgroundView]];
            }
        }
    }
    return @[];
}

@end
