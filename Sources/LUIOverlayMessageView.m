//
//  LUIOverlayMessageView.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIOverlayMessageView.h"

@interface LUIOverlayMessageView ()

@property (strong, nonnull) UIButton* message;

@end

@implementation LUIOverlayMessageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.backgroundColor = [UIColor redColor];
        self.message = [UIButton buttonWithType:UIButtonTypeSystem];
        self.message.tintColor = [UIColor whiteColor];
        [self.message setTitle:NSLocalizedString(@"View Accessibility Errors", @"Button title") forState:UIControlStateNormal];
        [self.message addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.message];
    }
    
    return self;
}

- (void)buttonTapped:(id)sender {
    [self.delegate overlayMessageViewChoseView:self];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.message sizeThatFits:size];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.message.frame = self.bounds;
}

@end
