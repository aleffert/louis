//
//  BadLabelFormatReportTests.swift
//  Louis
//
//  Created by Akiva Leffert on 2/29/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

import XCTest

import Louis

class BadLabelFormatReportTests: XCTestCase {

    func testIgnoresWhenNoLabel() {
        let label = UILabel()
        label.text = "some_string"

        XCTAssertEqual(label.lui_accessibilityReports().count, 0)
    }

    func testBadName() {
        let label = UILabel()
        label.accessibilityLabel = "some_string"
        let reports = LUIBadLabelFormatReport.reports(label)
        XCTAssertEqual(reports.count, 1)
        let report = reports.first as! LUIBadLabelFormatReport
        XCTAssertTrue(report.views.map { $0.view }.contains(label))
    }

}
