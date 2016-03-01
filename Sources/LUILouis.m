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
#import "LUIInsufficientContrastReport.h"
#import "LUIReport.h"

#import <objc/runtime.h>

@interface LUILouis ()

@property NSTimer* timer;

@end


void LUIDefaultLogger(NSArray<id<LUIReport>>* reports) {
    for(id<LUIReport> report in reports) {
        NSLog(@"Accessibility Error [%@]: %@", [report class], report.message);
    }
}

void LUIAssertionLogger(NSArray<id<LUIReport>>* reports) {
    LUIDefaultLogger(reports);
    NSCAssert(reports.count == 0, @"If any reports are incorrect, you can use -[UIView lui_ignoredClasses] on your failing view to hide them.");
}

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
        self.reportAction = ^(NSArray<id<LUIReport>>* reports) {LUIDefaultLogger(reports); };
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
    if(reports.count > 0) {
        self.reportAction(reports);
    }
}

- (void)checkTimerFired:(NSTimer*)timer {
    [self reportView:[UIApplication sharedApplication].keyWindow];
}

@end

static NSString* const LUIIgnoredReportClassesKey = @"LUIIgnoredReportClassesKey";

@implementation UIView (LUIReportExtensions)

- (NSArray<id<LUIReport>>*)lui_accessibilityReportsRecursive:(BOOL)recursive {
    NSMutableArray<id<LUIReport>>* reports = [[NSMutableArray alloc] init];

    for(Class reporter in [LUILouis reporters]) {
        if(![self.lui_ignoredClasses containsObject: [reporter identifier]]) {
            [reports addObjectsFromArray:[reporter reports:self]];
        }
    }

    if(recursive) {
        for(UIView* view in self.subviews) {
            [reports addObjectsFromArray:[view lui_accessibilityReportsRecursive:YES]];
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

