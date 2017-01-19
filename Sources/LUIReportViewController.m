//
//  LUIReportViewController.m
//  Louis
//
//  Created by Akiva Leffert on 12/26/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

#import "LUIReportViewController.h"

#import "UIColor+LUIConvenience.h"
#import "LUIReport.h"
#import "LUIViewRecord.h"

static const NSUInteger LUISwatchCornerRadius = 3;

@interface LUIButtonCell : UITableViewCell

@property (strong, nonnull) UIButton* button;

@end

@implementation LUIButtonCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self != nil) {
        self.button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.button];
        self.button.translatesAutoresizingMaskIntoConstraints = false;
        [self.button setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 10, 0)];
        
        for(NSNumber* attribute in @[
                                     @(NSLayoutAttributeHeight),
                                     @(NSLayoutAttributeWidth),
                                     @(NSLayoutAttributeCenterX),
                                     @(NSLayoutAttributeCenterY)
                                     ]) {
            [self.contentView addConstraint:
             [NSLayoutConstraint
              constraintWithItem:self.contentView
              attribute:attribute.intValue
              relatedBy:NSLayoutRelationEqual
              toItem:self.button
              attribute:attribute.intValue
              multiplier:1
              constant:0]
             ];
        }
        [self.button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return self;
}

@end

typedef NS_ENUM(NSUInteger, LUIReportViewSection) {
    LUIReportViewSectionDescription,
    LUIReportViewSectionSaveScreenshot,
    LUIReportViewSectionViews,
    LUIReportViewSectionCount
};

@interface LUIReportViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonnull) id<LUIReport> report;

@end

@implementation LUIReportViewController

- (id)initWithReport:(id<LUIReport>)report {
    self = [super initWithNibName:nil bundle:nil];
    if(self != nil) {
        self.report = report;
        self.navigationItem.title = NSLocalizedString(@"Report", @"Screen title");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Description"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"View"];
    [self.tableView registerClass:[LUIButtonCell class] forCellReuseIdentifier:@"Snapshot"];
}

// Cell helpers

- (UITableViewCell*)descriptionCellForTableView:(UITableView*)tableView {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Description"];
    cell.textLabel.text = [self.report message];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableViewCell*)saveScreenshotCellForTableView:(UITableView*)tableView {
    LUIButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Snapshot"];
    [cell.button setTitle:NSLocalizedString(@"Send Snapshot", @"Button title") forState:UIControlStateNormal];
    [cell.button removeTarget:self action:nil forControlEvents:UIControlEventAllEvents];
    [cell.button addTarget:self action:@selector(sendSnapshot:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGSize)swatchSize {
    return CGSizeMake(24, 24);
}

- (UITableViewCell*)viewItemCellForTableView:(UITableView*)tableView atIndex:(NSUInteger)index {
    LUIViewRecord* record = self.report.views[index];
    NSString* key = record.name;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Description"];
    cell.textLabel.text = key;
    
    UIView* view = record.view;
    UIColor* color = [self.delegate reportViewController:self highlighColorView:view];
    cell.imageView.isAccessibilityElement = NO;
    [cell.imageView setImage:[color lui_swatchOfSize:[self swatchSize]]];
    cell.imageView.clipsToBounds = YES;
    cell.imageView.layer.cornerRadius = LUISwatchCornerRadius;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// Table View Delegate/Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return LUIReportViewSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case LUIReportViewSectionSaveScreenshot:
            return 1;
        case LUIReportViewSectionDescription:
            return 1;
        case LUIReportViewSectionViews:
            return self.report.views.count;
        default:
            return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section) {
        case LUIReportViewSectionDescription:
            return [self descriptionCellForTableView:tableView];
        case LUIReportViewSectionSaveScreenshot:
            return [self saveScreenshotCellForTableView:tableView];
        case LUIReportViewSectionViews:
            return [self viewItemCellForTableView:tableView atIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // Removes extra padding in Grouped style
    return CGFLOAT_MIN;
}

- (void)sendSnapshot:(id)sender {
    [self.delegate reportViewController:self sendSnapshotForReport:self.report];
}

@end
