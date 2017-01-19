//
//  LUIViewRecord.m
//  Louis
//
//  Created by Akiva Leffert on 1/19/17.
//  Copyright © 2017 Akiva Leffert. All rights reserved.
//

#import "LUIViewRecord.h"

@interface LUIViewRecord ()

@property (strong, nonatomic) UIView* view;
@property (copy, nonatomic) NSString* name;

@end

@implementation LUIViewRecord

- (id)initWithName:(NSString*)name view:(UIView*)view {
    self = [super init];
    if(self != nil) {
        self.view = view;
        self.name = name;
    }
    return self;
}

@end
