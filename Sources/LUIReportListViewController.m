//
//  LUIReportListViewController.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIReportListViewController.h"

#import "LUIReport.h"

static NSString* const LUIReportListItemCellIdentifier = @"LUIReportListItemCellIdentifier";

@interface LUIReportListViewController ()

@property (copy, nonatomic) NSArray<id<LUIReport>>* reports;

@end

@implementation LUIReportListViewController

- (id)initWithReports:(NSArray<id<LUIReport>>*)reports {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        self.reports = reports;
        self.navigationItem.title = NSLocalizedString(@"Reports", @"Screen title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LUIReportListItemCellIdentifier];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reports.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LUIReportListItemCellIdentifier forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    id<LUIReport> report = self.reports[indexPath.row];
    cell.textLabel.text = report.category;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<LUIReport> report = self.reports[indexPath.row];
    [self.delegate reportListController:self choseReport:report];
}

@end
