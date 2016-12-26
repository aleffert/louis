//
//  LUILogger.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LUIReport;

/// Protocol for custom loggers.
@protocol LUILogger <NSObject>

/// Called by the system when it has items to report.
/// Typically reports are issued on a timer, so if a report is still relevant it will
/// be reported again.
/// @param reports List of reports. May be empty to indicate that there are no current issues.
- (void)logReports:(NSArray<id <LUIReport>>*)reports;

@end

NS_ASSUME_NONNULL_END
