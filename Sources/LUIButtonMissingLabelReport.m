//
//  LUIButtonMissingLabelReport.m
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIButtonMissingLabelReport.h"

#import "UIView+LUIVisibility.h"

NSString* LUIStringForControlState(UIControlState state) {
    switch (state) {
        case UIControlStateNormal: return @"normal";
        case UIControlStateSelected: return @"selected";
        case UIControlStateHighlighted: return @"highlighted";
        case UIControlStateDisabled: return @"disabled";
        case UIControlStateApplication: return @"application";
        case UIControlStateReserved: return @"reserved";
        case UIControlStateFocused: return @"focused";
        default: return [NSString stringWithFormat: @"unknown(%ld)", (unsigned long)state];
    }
}

@implementation LUIButtonMissingLabelReport

+ (NSString*)identifier {
    return @"button-missing-label";
}

- (id)initWithButton:(UIButton*)button invalidStates:(NSArray<NSString*>*)states {
    self = [super init];
    if(self != nil) {
        self.button = button;
        self.invalidStates = states;
    }
    return self;
}

- (NSString*)message {
    return [NSString stringWithFormat:@"Button %@ missing label for states: %@", self.button, self.invalidStates];
}

- (UIView*)view {
    return self.button;
}

+ (NSArray<id<LUIReport>>*)reports:(UIView *)view {
    if([view isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)view;
        NSMutableArray<NSString*>* invalidStates = [[NSMutableArray alloc] init];
        NSArray* possibleStates = @[@(UIControlStateNormal), @(UIControlStateDisabled), @(UIControlStateHighlighted), @(UIControlStateSelected)];
        for(NSNumber* stateValue in possibleStates) {
            UIControlState state = stateValue.integerValue;
            BOOL hasTitle = [button titleForState:state] != nil || [button attributedTitleForState:state].string != nil;
            if(!hasTitle && button.accessibilityLabel == nil) {
                [invalidStates addObject:LUIStringForControlState(state)];
            }
        }
        if(invalidStates.count > 0 && !view.lui_isInvisibleToAccessibility) {
            return @[[[LUIButtonMissingLabelReport alloc] initWithButton:button invalidStates:invalidStates]];
        }
    }
    return @[];
}

- (NSDictionary<NSString *,UIView *> *)views {
    return @{
             @"Button": self.button
             };
}

@end
