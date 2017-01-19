//
//  UIColor+LUIConvenience.m
//  Louis
//
//  Created by Akiva Leffert on 12/24/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "UIColor+LUIConvenience.h"
#import "UIImage+LUIConvenience.h"

@implementation UIColor (LUIConvenience)

- (BOOL)lui_isOpaque {
    CGFloat alpha = 1;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    return alpha == 1;
}

- (UIImage*)lui_swatchOfSize:(CGSize)size {
    return LUICaptureImage(size, NO, 1.0, ^{
        [self setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
    });
}

@end
