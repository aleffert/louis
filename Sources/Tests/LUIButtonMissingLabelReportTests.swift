//
//  ButtonMissingLabelTests.swift
//  Pods
//
//  Created by Akiva Leffert on 2/29/16.
//
//

import XCTest

import Louis

class ButtonMissingLabelReportTests: XCTestCase {

    func testNormalButtonNoReports() {
        let button = UIButton()
        button.setTitle("Some Title", forState: .Normal)
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
    }

    func testMissingTitleReports() {
        let button = UIButton(frame: CGRectMake(0, 0, 100, 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        let reports = LUIButtonMissingLabelReport.reports(button)
        XCTAssertEqual(reports.count, 1)
        let buttonReports = reports.flatMap { $0 as? LUIButtonMissingLabelReport }
        XCTAssertEqual(buttonReports.count, 1)
        let report = buttonReports[0]
        XCTAssertTrue(report.invalidStates.contains(LUIStringForControlState(.Normal)))
        XCTAssertEqual(report.view, button)
    }

    func testMissingTitleReportsSubStates() {
        let states = [UIControlState.Highlighted, .Selected, .Disabled]
        for state in states {
            let button = UIButton(frame: CGRectMake(0, 0, 100, 100))
            button.accessibilityTraits = UIAccessibilityTraitButton;
            button.setTitle("Some title", forState: state)
            let reports = LUIButtonMissingLabelReport.reports(button)
            XCTAssertEqual(reports.count, 1)
            let buttonReports = reports.flatMap { $0 as? LUIButtonMissingLabelReport }
            XCTAssertEqual(buttonReports.count, 1)
            let report = buttonReports[0]
            XCTAssertTrue(report.invalidStates.contains(LUIStringForControlState(.Normal)))
            for remainingState in states.filter({ $0 != state }) {
                XCTAssertTrue(report.invalidStates.contains(LUIStringForControlState(remainingState)))
            }
            XCTAssertFalse(report.invalidStates.contains(LUIStringForControlState(state)))
            XCTAssertEqual(report.view, button)
        }
    }

    func testHasLabelNoReports() {
        let button = UIButton()
        button.accessibilityLabel = "Some title"
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
    }

    func testIgnoreInvisible() {
        let button = UIButton(frame: CGRectMake(0, 0, 100, 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        XCTAssertEqual(button.lui_accessibilityReports().count, 1)
        button.hidden = true
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.hidden = false
        button.alpha = 0
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.alpha = 1
        button.bounds = CGRectMake(0, 0, 100, 0)
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.bounds = CGRectMake(0, 0, 0, 100)
    }

}
