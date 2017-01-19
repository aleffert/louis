//
//  LUIReportContainerViewController.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LUIReport;

@class LUIReportContainerViewController;

@protocol LUIReportContainerViewControllerDelegate

- (void)reportContainerWillCaptureScreenshot:(LUIReportContainerViewController*)container;
- (void)reportContainerDidCaptureScreenshot:(LUIReportContainerViewController*)container;

- (void)reportContainerWillFinish:(LUIReportContainerViewController*)container;
- (void)reportContainerDidFinish:(LUIReportContainerViewController*)container;

@end

@interface LUIReportContainerViewController : UIViewController

- (id)initWithReports:(NSArray<id<LUIReport>>*)reports window:(UIWindow*)window;

@property (weak, nonatomic) id<LUIReportContainerViewControllerDelegate> delegate;

- (void)present;

@end
