//
//  LUIBadLabelFormatReport.h
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LUIReport.h"

NS_ASSUME_NONNULL_BEGIN

@interface LUIBadLabelFormatReport : NSObject <LUIReport>

@property (readonly, copy, nonatomic) NSString* label;

@end

NS_ASSUME_NONNULL_END
