//
//  LUIConsoleLogger.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Louis/LUILogger.h>

NS_ASSUME_NONNULL_BEGIN

// Simple logger that just uses NSLog to write to errors to the console
@interface LUIConsoleLogger : NSObject <LUILogger>
@end

NS_ASSUME_NONNULL_END
