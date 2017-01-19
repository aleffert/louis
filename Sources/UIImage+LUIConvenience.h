//
//  UIImage+LUIConvenience.h
//  Louis
//
//  Created by Akiva Leffert on 12/24/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct
{
    Byte red;
    Byte green;
    Byte blue;
    Byte alpha;
    
} RGBAPixel;

@interface UIImage (LUIConvenience)

- (BOOL)lui_isOpaque;

@end

UIImage* LUICaptureImage(CGSize size, BOOL opaque, CGFloat scale, void(^actions)(void));
