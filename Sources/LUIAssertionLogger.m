//
//  LUIAssertionLogger.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIAssertionLogger.h"

@implementation LUIAssertionLogger

- (void)logReports:(NSArray<id<LUIReport>> *)reports {
    NSAssert(reports.count == 0, @"If any reports are incorrect, you can use -[UIView setLui_ignoredClasses] on your failing view to hide them.");
}

@end
