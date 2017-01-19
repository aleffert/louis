//
//  LUIViewHighlightController.m
//  Louis
//
//  Created by Akiva Leffert on 1/18/17.
//  Copyright © 2017 Akiva Leffert. All rights reserved.
//

#import "LUIViewHighlightController.h"

@interface LUIHighlightView: UIView
@end

@interface LUIHighlightView ()
@property (strong, nonatomic) UIView* baseView;
@property (strong, nonatomic) UIColor* color;
@end

@implementation LUIHighlightView

- (id)initWithBaseView:(UIView*)baseView color:(UIColor*)color {
    self = [super initWithFrame:CGRectZero];
    if(self != nil) {
        self.baseView = baseView;
        self.color = color;
        self.layer.borderColor = color.CGColor;
        self.layer.borderWidth = 3;

        self.backgroundColor = [color colorWithAlphaComponent:0.3];
    }
    return self;
}

@end

@interface LUIViewHighlightController ()

@property (strong, nonatomic) NSArray<LUIHighlightView*>* highlightViews;
@property (strong, nonatomic) NSMutableArray* remainingColors;

@end

@implementation LUIViewHighlightController

- (id)init {
    self = [super init];
    if(self != nil) {
        self.highlightViews = [[NSMutableArray alloc] init];
        self.remainingColors = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    for(UIView* view in self.highlightViews) {
        [view removeFromSuperview];
    }
}

- (NSArray<UIColor*>*)allColors {
    return @[
             [UIColor redColor],
             [UIColor blueColor],
             [UIColor orangeColor],
             [UIColor yellowColor],
             [UIColor cyanColor]
             ];
}

- (UIColor*)dequeueColor {
    if(self.remainingColors.count == 0) {
        [self.remainingColors addObjectsFromArray:[self allColors]];
    }
    UIColor* result = [self.remainingColors lastObject];
    [self.remainingColors removeLastObject];
    return result;
}

- (LUIHighlightView*)highlightForView:(UIView*)view {
    for(LUIHighlightView* highlight in self.highlightViews) {
        if(highlight.baseView == view) {
            return highlight;
        }
    }
    return nil;
}

- (UIColor*)highlightColorForView:(UIView*)view {
    return [[self highlightForView:view] color];
}

- (void)highlightViews:(NSArray<UIView*>*)views inContainer:(UIView*)container {
    NSMutableArray* highlights = [[NSMutableArray alloc] init];
    for(UIView* view in views) {
        UIView* highlight = [self highlightForView:view];
        if(highlight == nil) {
            highlight = [[LUIHighlightView alloc] initWithBaseView:view color:[self dequeueColor]];
            [highlights addObject:highlight];
        }
        [container addSubview:highlight];
        CGRect frame = [container convertRect:view.bounds fromView:view];
        NSLog(@"frame is %@", [NSValue valueWithCGRect:frame]);
        highlight.frame = frame;
    }
    
    self.highlightViews = highlights;
}

@end

