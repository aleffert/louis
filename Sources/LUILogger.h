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

@protocol LUILogger <NSObject>

- (void)logReports:(NSArray<id <LUIReport>>*)reports;

@end

NS_ASSUME_NONNULL_END
