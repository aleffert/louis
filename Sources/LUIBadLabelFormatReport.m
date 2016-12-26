//
//  LUIBadLabelFormatReport.m
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIBadLabelFormatReport.h"

BOOL LUIIsBadName(NSString* name) {
    return [name containsString:@"_"];
}

@interface LUIBadLabelFormatReport ()

@property (copy, nonatomic) NSString* label;
@property (strong, nonatomic) UIView* view;

@end

@implementation LUIBadLabelFormatReport

- (id)initWithView:(UIView*)view label:(NSString*)label {
    if(self != nil) {
        self.view = view;
        self.label = label;
    }
    return self;
}

+ (NSString*)identifier {
    return @"bad-label-format";
}

- (NSString*)message {
    return [NSString stringWithFormat: @"View %@ has a bad name: %@.", self.view, self.label];

}

+ (NSArray<id<LUIReport>>*)reports:(UIView *)view {
    NSString* label = view.accessibilityLabel;
    if(label != nil && LUIIsBadName(label)) {
        return @[[[LUIBadLabelFormatReport alloc] initWithView:view label:label]];
    }
    else {
        return @[];
    }
}

- (NSDictionary<NSString*, UIView*>*)views {
    return @{
             @"Label": self.view
             };
}

@end
