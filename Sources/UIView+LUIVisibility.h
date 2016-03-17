//
//  UIView+LUIVisibility.h
//  Louis
//
//  Created by Akiva Leffert on 3/17/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LUIVisibility)

/// Views can become invisible for a variety of reasons, like having alpha, width or height = 0.
/// This provides an easy way to detect if a view should be ignored
@property (readonly, assign) BOOL lui_isInvisibleToAccessibility;

@end
