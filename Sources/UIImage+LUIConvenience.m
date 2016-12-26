//
//  UIImage+LUIConvenience.m
//  Louis
//
//  Created by Akiva Leffert on 12/24/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "UIImage+LUIConvenience.h"

@implementation UIImage (LUIConvenience)

- (BOOL)lui_hasAlphaProperties {
    switch(CGImageGetAlphaInfo(self.CGImage)) {
        case kCGImageAlphaFirst:
        case kCGImageAlphaLast:
        case kCGImageAlphaPremultipliedFirst:
        case kCGImageAlphaPremultipliedLast:
            return true;
        default:
            return false;
    }
}

- (BOOL)lui_pixelsHaveAlpha {
    size_t width = 3;
    size_t height = 3;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, cs, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = height}, self.CGImage);
    CGColorSpaceRelease(cs);
    
    BOOL foundAlpha = NO;
    
    const RGBAPixel* pixels = (const RGBAPixel*)CGBitmapContextGetData(bmContext);
    for (NSUInteger y = 0; y < height; y++) {
        for (NSUInteger x = 0; x < width; x++) {
            const NSUInteger index = x + y * width;
            RGBAPixel pixel = pixels[index];
            if(pixel.alpha < 255) {
                foundAlpha = YES;
                goto done;
            }
        }
    }
    
done:
    CGContextRelease(bmContext);
    return foundAlpha;
}

- (BOOL)lui_isOpaque {
    return !([self lui_hasAlphaProperties] && [self lui_pixelsHaveAlpha]);
}

@end
