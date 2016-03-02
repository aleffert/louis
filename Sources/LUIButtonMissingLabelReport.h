//
//  LUIButtonMissingLabelReport.h
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LUIReport.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString* LUIStringForControlState(UIControlState state);

@interface LUIButtonMissingLabelReport : NSObject <LUIReport>

/// The button that is missing a label
@property (strong, nonatomic) UIButton* button;

/// The @p UIControlStates that are missing labels converted to human readable strings
@property (strong, nonatomic) NSArray<NSString*>* invalidStates;

@end

NS_ASSUME_NONNULL_END
