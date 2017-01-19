//
//  LUIViewHighlightController.h
//  Louis
//
//  Created by Akiva Leffert on 1/18/17.
//  Copyright © 2017 Akiva Leffert. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LUIViewHighlightController: NSObject

- (void)highlightViews:(NSArray<UIView*>*)views inContainer:(UIView*)container;
- (UIColor*)highlightColorForView:(UIView*)view;

@end

NS_ASSUME_NONNULL_END
