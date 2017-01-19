//
//  LUIReportViewController.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LUIReport;

@class LUIReportViewController;

@protocol LUIReportViewControllerDelegate <NSObject>

- (UIColor*)reportViewController:(LUIReportViewController*)controller highlighColorView:(UIView*)view;

- (void)reportViewController:(LUIReportViewController*)controller sendSnapshotForReport:(id<LUIReport>)report;

@end

@interface LUIReportViewController : UIViewController

- (id)initWithReport:(id<LUIReport>)report;

@property (weak, nonatomic) id<LUIReportViewControllerDelegate> delegate;

@end
