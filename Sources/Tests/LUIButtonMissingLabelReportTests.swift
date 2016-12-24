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
        button.setTitle("Some Title", for: UIControlState())
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
    }

    func testMissingTitleReports() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        let reports = LUIButtonMissingLabelReport.reports(button)
        XCTAssertEqual(reports.count, 1)
        let buttonReports = reports.flatMap { $0 as? LUIButtonMissingLabelReport }
        XCTAssertEqual(buttonReports.count, 1)
        let report = buttonReports[0]
        XCTAssertTrue(report.invalidStates.contains(LUIStringForControlState(UIControlState())))
        XCTAssertEqual(report.view, button)
    }

    func testMissingTitleReportsSubStates() {
        let states = [UIControlState.highlighted, .selected, .disabled]
        for state in states {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            button.accessibilityTraits = UIAccessibilityTraitButton;
            button.setTitle("Some title", for: state)
            let reports = LUIButtonMissingLabelReport.reports(button)
            XCTAssertEqual(reports.count, 1)
            let buttonReports = reports.flatMap { $0 as? LUIButtonMissingLabelReport }
            XCTAssertEqual(buttonReports.count, 1)
            let report = buttonReports[0]
            XCTAssertTrue(report.invalidStates.contains(LUIStringForControlState(UIControlState())))
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
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.accessibilityTraits = UIAccessibilityTraitButton
        XCTAssertEqual(button.lui_accessibilityReports().count, 1)
        button.isHidden = true
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.isHidden = false
        button.alpha = 0
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.alpha = 1
        button.bounds = CGRect(x: 0, y: 0, width: 100, height: 0)
        XCTAssertEqual(button.lui_accessibilityReports().count, 0)
        button.bounds = CGRect(x: 0, y: 0, width: 0, height: 100)
    }

}
