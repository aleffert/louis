//
//  LUIAssertionLogger.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Louis/LUILogger.h>

NS_ASSUME_NONNULL_BEGIN

// Simple logger that just uses NSAssert to break when there are errors
@interface LUIAssertionLogger : NSObject <LUILogger>
@end

NS_ASSUME_NONNULL_END
