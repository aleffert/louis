//
//  LUIOverlayMessageView.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LUIOverlayMessageView;

@protocol LUIOverlayMessageViewDelegate <NSObject>

- (void)overlayMessageViewChoseView:(LUIOverlayMessageView*)view;

@end

@interface LUIOverlayMessageView : UIView

@property (weak, nonatomic) id <LUIOverlayMessageViewDelegate> delegate;

@end
