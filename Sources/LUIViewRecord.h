//
//  LUIViewRecord.h
//  Louis
//
//  Created by Akiva Leffert on 1/19/17.
//  Copyright © 2017 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface LUIViewRecord : NSObject

- (id)initWithName:(NSString*)name view:(UIView*)view;

@property (readonly, strong, nonatomic) UIView* view;
@property (readonly, copy, nonatomic) NSString* name;

@end
