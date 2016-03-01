//
//  LUILouis.h
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LUIReport;

void LUIDefaultLogger(NSArray<id<LUIReport>>* reports);
void LUIAssertionLogger(NSArray<id<LUIReport>>* reports);

@interface LUILouis : NSObject

/// Shared singleton for Louis.
+ (instancetype)shared;

/// Constructs a new accessibility checker. Note that for convenience you can access Louis through its shared singleton.
- (id)init;

/// How to report bubble up errors. The default is Louis.defaultLogger
@property (copy, nonatomic) void (^reportAction)(NSArray<id<LUIReport>>*);

/// Interval between traversals of the view hierarchy when @p timedCheckEnabled is @p YES. Defaults to 3 seconds.
@property (assign, nonatomic) NSTimeInterval timedCheckInterval;

/// Enable checking for accessibility problems on a timer. Timer interval is controlled by the @p timedCheckInterval property.
@property (assign, nonatomic) BOOL timedCheckEnabled;

/// Report accessibility problems for the given view and its recursive descendents.
/// @param view The view to analyze.
- (void)reportView:(UIView*)view;

@end


@interface UIView (LUIReportExtensions)

/// To explicitly disable a report you can set the @p ignoredReportClasses property of the view.
/// @param recursive Whether to recurse down through the view's subview hierarchy.
/// @returns The accessibility reports for the receiver.
- (NSArray<id<LUIReport>>*)lui_accessibilityReportsRecursive:(BOOL)recursive;

/// To explicitly disable a report you can set the @p ignoredReportClasses property of the view. Same as calling @p lui_accessibilityReportsRecursive with @p YES.
/// @returns The accessibility reports for the receiver
- (NSArray<id<LUIReport>>*)lui_accessibilityReports;

/// Setting this will allow you to ignore specific reports. Just add @p SomeReporterClass.identifer.
@property (copy, nonatomic) NSArray<NSString*>* lui_ignoredClasses;

@end



NS_ASSUME_NONNULL_END
