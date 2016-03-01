//
//  LUIInsufficientContrastReport.h
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Louis/LUIReport.h>

NS_ASSUME_NONNULL_BEGIN

@interface LUIInsufficientContrastReport : NSObject <LUIReport>

@property (readonly, strong, nonatomic) UIView* backgroundView;

@end

NS_ASSUME_NONNULL_END
