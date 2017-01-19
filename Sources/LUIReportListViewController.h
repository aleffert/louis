//
//  LUIReportListView.h
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LUIReport;

@class LUIReportListViewController;

@protocol LUIReportListViewControllerDelegate <NSObject>

- (void)reportListController:(LUIReportListViewController*)controller choseReport:(id<LUIReport>)report;

@end

@interface LUIReportListViewController : UITableViewController

- (id)initWithReports:(NSArray<id<LUIReport>>*)reports;

@property (weak, nonatomic) id<LUIReportListViewControllerDelegate> delegate;

@end
