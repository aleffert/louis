//
//  LUIConsoleLogger.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIConsoleLogger.h"

#import "LUIReport.h"

@implementation LUIConsoleLogger

- (void)logReports:(NSArray<id<LUIReport>> *)reports {
    for(id<LUIReport> report in reports) {
        NSLog(@"Accessibility Error [%@]: %@", [report class], report.message);
    }
}

@end
