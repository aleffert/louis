//
//  LUIVisualLogger.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

@import UIKit;

#import "LUIVisualLogger.h"
#import "LUIOverlayMessageView.h"
#import "LUIReportContainerViewController.h"

@interface LUIVisualLogger () <LUIOverlayMessageViewDelegate, LUIReportContainerViewControllerDelegate>

@property (copy, nonatomic) NSArray <id<LUIReport>>* reports;

@property (strong, nonatomic) LUIOverlayMessageView* messageView;

@property (strong, nonatomic) UIWindow* overlayWindow;

@end

@implementation LUIVisualLogger

- (id)init {
    self = [super init];
    if(self != nil) {
        self.messageView = [[LUIOverlayMessageView alloc] init];
        self.messageView.alpha = 0;
        self.messageView.delegate = self;
    }
    
    return self;
}

- (void)logReports:(NSArray<id<LUIReport>> *)reports {
    self.reports = reports;
    if(reports.count > 0) {
        [self showFooter];
    }
    else {
        [self hideFooter];
    }
}

- (void)showFooter {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview: self.messageView];
    
    CGSize size = [self.messageView sizeThatFits:window.bounds.size];
    size.width = window.bounds.size.width;
    
    self.messageView.frame = CGRectMake(0, window.bounds.size.height - size.height, size.width, size.height);
    self.messageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageView.alpha = 1;
    }];
}

- (void)hideFooter {
    [UIView animateWithDuration:0.2 animations:^{
        self.messageView.alpha = 0;
    } completion:^(BOOL finished) {
        if(finished && self.messageView.alpha == 0) {
            [self.messageView removeFromSuperview];
        }
    }];
}

- (void)showReportList {
    UIWindow* window = [[UIWindow alloc] init];
    
    LUIReportContainerViewController* reportController = [[LUIReportContainerViewController alloc] initWithReports:self.reports window:[[UIApplication sharedApplication] keyWindow]];
    reportController.delegate = self;

    window.rootViewController = reportController;
    [window setWindowLevel:UIWindowLevelAlert];
    window.hidden = false;
    window.alpha = 0;
    window.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [UIView animateWithDuration:0.3 animations:^{
        window.alpha = 0.8;
    }];
    self.overlayWindow = window;
    [reportController present];
}

- (void)overlayMessageViewChoseView:(LUIOverlayMessageView *)view {
    [self showReportList];
}

- (void)reportContainerWillFinish:(LUIReportContainerViewController *)container {
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayWindow.alpha = 0;
    }];
}

- (void)reportContainerDidFinish:(LUIReportContainerViewController *)container {
    self.overlayWindow = nil;
}

- (void)reportContainerWillCaptureScreenshot:(LUIReportContainerViewController *)container {
    self.messageView.hidden = true;
}

- (void)reportContainerDidCaptureScreenshot:(LUIReportContainerViewController *)container {
    self.messageView.hidden = false;
}

@end
