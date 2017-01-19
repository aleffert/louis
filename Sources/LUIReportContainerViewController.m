//
//  LUIReportContainerViewController.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIReportContainerViewController.h"

#import "LUIViewHighlightController.h"
#import "LUIReport.h"
#import "LUIReportListViewController.h"
#import "LUIReportViewController.h"

#import "UIImage+LUIConvenience.h"


static const CGFloat LUIFooterHeight = 220;

@interface LUIReportContainerViewController () <LUIReportListViewControllerDelegate, LUIReportViewControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UINavigationController* navController;
@property (strong, nonatomic) LUIReportListViewController* reportListController;
@property (strong, nonatomic) LUIViewHighlightController* highlightController;
@property (strong, nonatomic) UIView* overlayContainer;
@property (strong, nonatomic) UIWindow* window;

@end

@implementation LUIReportContainerViewController

- (id)initWithReports:(NSArray<id<LUIReport>> *)reports window:(UIWindow*)window {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        
        self.window = window;
        
        self.overlayContainer = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.overlayContainer];
        
        self.reportListController = [[LUIReportListViewController alloc] initWithReports:reports];
        self.reportListController.delegate = self;
        self.navController = [[UINavigationController alloc] initWithRootViewController:self.reportListController];
        [self addChildViewController:self.navController];
        [self.view addSubview:self.navController.view];
        self.reportListController.navigationItem.rightBarButtonItem = [self doneButton];
        
        [self.navController didMoveToParentViewController:self];
    }
    return self;
}

- (void)present {
    self.navController.view.transform = CGAffineTransformMakeTranslation(0, self.navController.view.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        self.navController.view.transform = CGAffineTransformIdentity;
    }];
}


- (void)done:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.navController.view.transform = CGAffineTransformMakeTranslation(0, self.navController.view.bounds.size.height);
        [self.delegate reportContainerWillFinish:self];
    } completion:^(BOOL finished) {
        [self.delegate reportContainerDidFinish:self];
     }];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = LUIFooterHeight;
    self.navController.view.bounds = CGRectMake(0, 0, width, height);
    self.navController.view.center = CGPointMake(width / 2, self.view.bounds.size.height - height / 2);
    self.navController.delegate = self;
    
    self.overlayContainer.frame = self.view.bounds;
}

- (UIBarButtonItem*)doneButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
}

- (void)highlightViewsOfReport:(id<LUIReport>)report {
    self.highlightController = [[LUIViewHighlightController alloc] init];
    [self.highlightController highlightViews:[[report views] allValues] inContainer:self.overlayContainer];
}

- (void)reportListController:(LUIReportListViewController *)controller choseReport:(id<LUIReport>)report {
    LUIReportViewController* reportController = [[LUIReportViewController alloc] initWithReport:report];
    reportController.navigationItem.rightBarButtonItem = [self doneButton];
    reportController.delegate = self;
    [self.navController pushViewController:reportController animated:YES];
    
    [self highlightViewsOfReport:report];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(navigationController.viewControllers.count < 2) {
        self.highlightController = nil;
    }
}

- (UIColor*)reportViewController:(LUIReportViewController *)controller highlighColorView:(UIView *)view {
    return [self.highlightController highlightColorForView:view];
}

- (UIImage*)snapshotImage {
    [self.delegate reportContainerWillCaptureScreenshot:self];
    UIImage* result = LUICaptureImage(self.window.bounds.size, NO, 0.0, ^{
        [self.window drawViewHierarchyInRect:self.window.bounds afterScreenUpdates:YES];
        [self.overlayContainer drawViewHierarchyInRect:self.window.bounds afterScreenUpdates:YES];
    });
    [self.delegate reportContainerDidCaptureScreenshot:self];
    return result;
}

- (void)reportViewController:(LUIReportViewController *)controller sendSnapshotForReport:(id<LUIReport>)report {
    UIImage* image = [self snapshotImage];
    NSString* text = [report message];
    UIActivityViewController* activityController = [[UIActivityViewController alloc] initWithActivityItems:@[image, text] applicationActivities:@[]];
    [self presentViewController:activityController animated:YES completion:nil];
}

@end
