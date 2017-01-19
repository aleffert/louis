//
//  LUIInsufficientContrastReport.m
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIInsufficientContrastReport.h"

#import "UIColor+LUIConvenience.h"
#import "UIImage+LUIConvenience.h"

static CGFloat LUIMinimumContrast = .2;

@interface LUIInsufficientContrastReport ()

@property (strong, nonatomic) UIView* view;
@property (strong, nonatomic) UIView* backgroundView;

@end

typedef struct {
    CGFloat min;
    CGFloat max;
} LuminanceRange;


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
    // Downsize - we don't really need the full image granularity
    // and we don't want to account for outliers anyway
    NSInteger width = MIN(CGImageGetWidth(imageRep), 10);
    NSInteger height = MIN(CGImageGetHeight(imageRep), 10);

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

// Helpers

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
        if(imageView.image == nil) {
            return @[];
        }
        else if((imageView.image.renderingMode == UIImageRenderingModeAlwaysTemplate || (imageView.image.renderingMode == UIImageRenderingModeAutomatic && [[view superview] isKindOfClass:[UIButton class]])) && imageView.tintColor != nil) {
            return @[@(LUILuminanceForColor(imageView.tintColor))];
        }
        else {
            LuminanceRange range = LUILuminanceForImage(imageView.image);
            return @[@(range.min), @(range.max)];
        }
    }
    return @[];
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
    else if([view isKindOfClass:[UINavigationBar class]]) {
        UINavigationBar* bar = (UINavigationBar*)view;
        UIColor* color = [bar.barTintColor lui_colorIgnoringClear];
        if(color != nil) {
            return @[@(LUILuminanceForColor(color))];
        }
    }
    
    UIColor* color = [view.backgroundColor lui_colorIgnoringClear];
    if(color) {
        return @[@(LUILuminanceForColor(color))];
    }
    
    return @[];
}

+ (BOOL)isViewOpaque:(UIView*)view {
    // Naively one might think you could just call -[UIView isOpaque] here
    // But that only works on some views that actually implement drawRect
    // and also doesn't account for opaque backgroundColors
    if(view.backgroundColor.lui_isOpaque) {
        return YES;
    }
    else if([view isKindOfClass:[UIImageView class]]) {
        UIImageView* imageView = (UIImageView*)view;
        switch(imageView.image.renderingMode) {
            case UIImageRenderingModeAlwaysTemplate:
                return [imageView.tintColor lui_isOpaque] && [imageView.image lui_isOpaque];
            case UIImageRenderingModeAlwaysOriginal:
                return [imageView.image lui_isOpaque];
            case UIImageRenderingModeAutomatic:
                // Not enough information, but since we don't know if tintColor applies,
                // can't use it
                return [imageView.image lui_isOpaque];
        }
    }
    // View classes that are known to be opaque, but aren't obviously opaque
    else if([@[@"_UIAlertControllerView"] containsObject:[[view class] description]]) {
        return YES;
    }
    else {
        return NO;
    }
}

// Returns all siblings of view that contain baseView
+ (NSArray<UIView*>*)siblingsOfView:(UIView*)view underlyingView:(UIView*)baseView {
    NSArray<UIView*>* siblings = [[view superview] subviews];
    NSUInteger currentIndex = [siblings indexOfObject:view];
    NSMutableArray<UIView*>* result = [NSMutableArray array];
    CGRect baseFrame = baseView.frame;
    for(NSInteger i = 0; i < currentIndex; i++) {
        UIView* sibling = siblings[i];
        CGRect convertedBounds = [baseView convertRect:baseFrame toView:sibling];
        if(CGRectEqualToRect(CGRectIntersection(sibling.bounds, convertedBounds), convertedBounds)) {
            [result addObject:sibling];
        }
    }
    return result;
}


// Construction

- (id)initWithView:(UIView*)view backgroundView:(UIView*)backgroundView {
    self = [super init];
    if(self != nil) {
        self.view = view;
        self.backgroundView = backgroundView;
    }
    return self;
}

// LUIReport

- (NSString*)category {
    return NSLocalizedString(
                             @"Insufficient Contrast",
                             @"Description of error category"
                             );
}

- (NSString*)message {
    return NSLocalizedString(@"Foreground has insufficient contrast with its background.", "Error description");
}

+ (NSString*)identifier {
    return @"insufficient-contrast";
}

+ (NSArray<id<LUIReport>>*)reportsForView:(UIView*)view backgroundView:(UIView*)backgroundView backgroundLuminosities:(NSArray<NSNumber*>*)backgroundLuminosities {
    
    NSArray<NSNumber*>* foregrounds = [self foregroundLuminanceForView:view];
    for(NSNumber* foreground in foregrounds) {
        for(NSNumber* background in backgroundLuminosities) {
            if(LUILuminanceLacksContrast(foreground.floatValue, background.floatValue)) {
                return @[[[LUIInsufficientContrastReport alloc] initWithView:view backgroundView:backgroundView]];
            }
        }
    }
    return @[];
}



//for current in parent-chain:
//  for sibling in current + reverse(overlapping-siblings):
//      check-sibling(sibling, view)
//
//check-sibling(sibling, view)
//  post-order-traversal
//
//post-order-traversal(sibling, view)
//  collect-possible-children(sibling, view)
//  foreach child

+ (NSArray<id<LUIReport>>*)traverseTreeForView:(UIView*)view withBackgroundView:(UIView*)backgroundView {
    NSMutableArray<UIView*>* underlyingSiblings = [self siblingsOfView:backgroundView underlyingView:view].mutableCopy;
    
    UIView* nearestBackgroundView = backgroundView;
    NSArray<NSNumber*>* nearestBackgroundLuminosities = [self backgroundLuminositiesOfView:backgroundView];
    BOOL opaque = [self isViewOpaque:nearestBackgroundView];
    while(!opaque && underlyingSiblings.count > 0 && nearestBackgroundLuminosities.count == 0) {
        // Traverse backwards to match z order
        nearestBackgroundView = [underlyingSiblings lastObject];
        [underlyingSiblings removeLastObject];
        
        nearestBackgroundLuminosities = [self backgroundLuminositiesOfView:nearestBackgroundView];
        
        opaque = [self isViewOpaque:nearestBackgroundView];
    }
    
    if(opaque || nearestBackgroundLuminosities.count > 0 || backgroundView.superview == nil) {
        return [self reportsForView: view backgroundView: nearestBackgroundView backgroundLuminosities: nearestBackgroundLuminosities];
    }
    else {
        return [self traverseTreeForView:view withBackgroundView:backgroundView.superview];
    }
}

+ (NSArray<id<LUIReport>>*)reports:(UIView *)view {
    return [self traverseTreeForView: view withBackgroundView:view];
}

- (NSDictionary<NSString *,UIView *> *)views {
    return @{
             @"Foreground": self.view,
             @"Background": self.backgroundView
             };
}

@end
