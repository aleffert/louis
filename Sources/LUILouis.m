//
//  LUILouis.m
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUILouis.h"

#import "LUIBadLabelFormatReport.h"
#import "LUIButtonMissingLabelReport.h"
#import "LUIConsoleLogger.h"
#import "LUIInsufficientContrastReport.h"
#import "LUILogger.h"
#import "LUIReport.h"
#import "LUIVisualLogger.h"

#import <objc/runtime.h>

static NSTimeInterval LUIDefaultTimedCheckInterval = 3;

@interface LUILouis ()

@property NSTimer* timer;

@end

@implementation LUILouis

+ (instancetype)shared {
    static LUILouis* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[LUILouis alloc] init];
    });
    return shared;
}

+ (NSArray<Class>*)reporters {
    return @[
             [LUIBadLabelFormatReport class],
             [LUIButtonMissingLabelReport class],
             [LUIInsufficientContrastReport class],
             ];
}

- (id)init {
    self = [super init];
    if(self != nil) {
        self.timedCheckInterval = LUIDefaultTimedCheckInterval;
        self.loggers = @[
                         [[LUIConsoleLogger alloc] init],
                         [[LUIVisualLogger alloc] init]
                         ];
    }
    return self;
}

- (void)setTimedCheckInterval:(NSTimeInterval)timedCheckInterval {
    _timedCheckInterval = timedCheckInterval;
    [self cancelTimer];
    [self enableTimer];
}

- (void)setTimedCheckEnabled:(BOOL)timedCheckEnabled {
    _timedCheckEnabled = timedCheckEnabled;
    if(self.timedCheckEnabled && self.timer == nil) {
        [self enableTimer];
    }
    else if(!self.timedCheckEnabled && self.timer != nil) {
        [self cancelTimer];
    }
}

- (void)cancelTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)enableTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timedCheckInterval target:self selector:@selector(checkTimerFired:) userInfo:nil repeats:YES];
}

- (void)reportView:(UIView*)view {
    NSArray<id<LUIReport>>* reports = [view lui_accessibilityReports];
    for(id<LUILogger> logger in self.loggers) {
        [logger logReports:reports];
    }
}

- (void)checkTimerFired:(NSTimer*)timer {
    [self reportView:[UIApplication sharedApplication].keyWindow];
}

- (void)addLogger:(id<LUILogger>)logger {
    NSMutableArray<id<LUILogger>>* loggers = self.loggers.mutableCopy;
    [loggers addObject:logger];
    self.loggers = loggers;
}

- (void)removeLogger:(id<LUILogger>)logger {
    NSMutableArray<id<LUILogger>>* loggers = self.loggers.mutableCopy;
    [loggers removeObject:logger];
    self.loggers = loggers;
}

@end

static NSString* const LUIIgnoredReportClassesKey = @"LUIIgnoredReportClassesKey";

@implementation UIView (LUIReportExtensions)

- (NSArray<id<LUIReport>>*)lui_accessibilityReportsRecursive:(BOOL)recursive {
    return [self lui_accessibilityReportsRecursive:recursive reporters:[LUILouis reporters]];
}

- (NSArray<id<LUIReport>>*)lui_accessibilityReportsRecursive:(BOOL)recursive reporters:(NSArray<Class> *)reporters {
    NSMutableArray<id<LUIReport>>* reports = [[NSMutableArray alloc] init];
    
    for(Class reporter in reporters) {
        if(![self.lui_ignoredClasses containsObject: [reporter identifier]]) {
            [reports addObjectsFromArray:[reporter reports:self]];
        }
    }
    
    if(recursive) {
        for(UIView* view in self.subviews) {
            [reports addObjectsFromArray:[view lui_accessibilityReportsRecursive:YES reporters:reporters]];
        }
    }
    return reports;
}

- (NSArray<id<LUIReport>>*)lui_accessibilityReports {
    return [self lui_accessibilityReportsRecursive:YES];
}

- (void)setLui_ignoredClasses:(NSArray<NSString *> *)classes {
    objc_setAssociatedObject(self, &LUIIgnoredReportClassesKey, classes, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray<NSString*>*)lui_ignoredClasses {
    return objc_getAssociatedObject(self, &LUIIgnoredReportClassesKey) ?: @[];
}


@end

