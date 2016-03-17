//
//  UIView+LUIVisibility.m
//  Louis
//
//  Created by Akiva Leffert on 3/17/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "UIView+LUIVisibility.h"

@implementation UIView (LUIVisibility)


- (BOOL)lui_isInvisibleToAccessibility {
    UIView* view = self;
    BOOL invisible = NO;
    while(view != nil) {
        invisible = invisible || self.alpha == 0 || self.hidden || self.bounds.size.width == 0 || self.bounds.size.height == 0;
        view = view.superview;
    }

    // Note that running tests in a framework target borks the defaults, so if you this behaves unexpectedly
    // while writing an automated tests you should make sure to set accessibilityTraits explicitly.
    return invisible || (self.accessibilityTraits & UIAccessibilityTraitNotEnabled) || (self.accessibilityTraits == UIAccessibilityTraitNone);
}

@end
