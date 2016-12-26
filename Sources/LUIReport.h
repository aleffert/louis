//
//  LUIReporter.h
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

@import Foundation;
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@protocol LUIReport <NSObject>

+ (NSArray<id<LUIReport>>*)reports:(UIView*)view;
+ (NSString*)identifier;

@property (readonly, copy, nonatomic) NSString* message;
@property (readonly, copy, nonatomic) NSDictionary<NSString*, UIView*>* views;

@end

NS_ASSUME_NONNULL_END
