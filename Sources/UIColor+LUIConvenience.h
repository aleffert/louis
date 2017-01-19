//
//  UIColor+LUIConvenience.h
//  Louis
//
//  Created by Akiva Leffert on 12/24/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LUIConvenience)

- (BOOL)lui_isOpaque;

- (UIImage*)lui_swatchOfSize:(CGSize)size;

@end
