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


CGFloat LUILuminanceForColor(UIColor* color) {
    CGFloat r, g, b;
    [color getRed:&r green:&g blue:&b alpha:NULL];
    return r * .2126 + g * 0.7152 + b * 0.0722;
}

BOOL LUIColorsLackContrast(UIColor* foreground, UIColor* background) {
    if (foreground == nil || background == nil) {
        return NO;
    }
    CGFloat foregroundLuminance = LUILuminanceForColor(foreground);
    CGFloat backgroundLuminance = LUILuminanceForColor(background);

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

+ (NSSet<UIColor*>*)foregroundColorsForView:(UIView*)view {
    if([view isKindOfClass:[UILabel class]]) {
        NSMutableSet* result = [[NSMutableSet alloc] init];
        UILabel* label = (UILabel*)view;
        for(NSUInteger i = 0; i < label.text.length; i++) {
            UIColor* color = [label.attributedText attribute:NSForegroundColorAttributeName atIndex:i effectiveRange:NULL] ?: label.textColor ?: label.tintColor ?: [UIColor blackColor]; // black is the default
            [result addObject:color];
        }
        return result;
    }
    if([view isKindOfClass:[UIImageView class]]) {
        UIImageView* imageView = (UIImageView*)view;
        if(imageView.image.renderingMode == UIImageRenderingModeAlwaysTemplate && imageView.tintColor != nil) {
            return [[NSSet alloc] initWithArray:@[imageView.tintColor]];
        }
    }
    return [NSSet set];
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

+ (NSArray<id<LUIReport>>*)reports:(UIView *)view {
    UIView* nearestBackgroundView = view;
    UIColor* nearestBackgroundColor = nil;
    while(nearestBackgroundView != nil && nearestBackgroundColor == nil) {
        nearestBackgroundColor = nearestBackgroundView.backgroundColor.lui_colorIgnoringClear;
        if(nearestBackgroundColor == nil) {
            nearestBackgroundView = nearestBackgroundView.superview;
        }
    }

    NSSet<UIColor*>* foregroundColors = [self foregroundColorsForView:view];
    for(UIColor* foregroundColor in foregroundColors) {
        if(LUIColorsLackContrast(foregroundColor, nearestBackgroundColor)) {
            return @[[[LUIInsufficientContrastReport alloc] initWithView:view backgroundView:nearestBackgroundView]];
        }
    }
    return @[];
}

@end
