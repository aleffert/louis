//
//  UIColor+LUIConvenience.m
//  Louis
//
//  Created by Akiva Leffert on 12/24/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "UIColor+LUIConvenience.h"

@implementation UIColor (LUIConvenience)

- (BOOL)lui_isOpaque {
    CGFloat alpha = 1;
    [self getRed:NULL green:NULL blue:NULL alpha:&alpha];
    return alpha == 1;
}

@end
