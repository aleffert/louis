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

/// Return all reports for this view.
+ (NSArray<id<LUIReport>>*)reports:(UIView*)view;

/// A unique identifier for the class of reports. Used for filtering out reports for
/// specific views
+ (NSString*)identifier;

/// A user facing string describing the error
@property (readonly, copy, nonatomic) NSString* message;

/// A set of relevant views and user facing string describing each view's rule in the report
@property (readonly, copy, nonatomic) NSDictionary<NSString*, UIView*>* views;

@end

NS_ASSUME_NONNULL_END
