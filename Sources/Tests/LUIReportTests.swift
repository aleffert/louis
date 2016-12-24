//
//  ReportTests.swift
//  Louis
//
//  Created by Akiva Leffert on 2/29/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

import XCTest

import Louis

class ReportTests: XCTestCase {

    func testReports() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        let reports = button.lui_accessibilityReports()
        XCTAssertEqual(reports.count, 1)
    }

    func testIgnored() {
        let button = UIButton()
        button.lui_ignoredClasses = [LUIButtonMissingLabelReport.identifier()]
        let reports = button.lui_accessibilityReports()
        XCTAssertEqual(reports.count, 0)
    }

    func testRecursive() {
        let view = UIView()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        view.addSubview(button)
        let reports = button.lui_accessibilityReports()
        XCTAssertEqual(reports.count, 1)
    }

    func testIgnoringNotRecursive() {
        let view = UIView()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        view.addSubview(button)
        let reports = button.lui_accessibilityReports()
        view.lui_ignoredClasses = [LUIButtonMissingLabelReport.identifier()]
        XCTAssertEqual(reports.count, 1)
    }
}
