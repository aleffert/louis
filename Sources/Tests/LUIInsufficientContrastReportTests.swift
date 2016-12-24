//
//  LUIInsufficientContrastReportTests.swift
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

import XCTest
import Louis

class LUIInsufficientContrastReportTests: XCTestCase {
    func testLabelTextOnSimilarBackground() {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.black
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 1)
    }

    func testDifferentBackgroundNoReport() {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 0)
    }

    func testDifferentParentBackground() {
        let container = UIView()
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Test"
        container.backgroundColor = UIColor.black
        container.addSubview(label)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)

        // Now swap and make sure we get the same result
        label.textColor = UIColor.black
        container.backgroundColor = UIColor.white

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testNoBackground() {
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Test"

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testImageTint() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), true, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white

        let container = UIView()
        container.backgroundColor = UIColor(white: 0.96, alpha: 1)
        container.addSubview(imageView)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(imageView).count, 1)
    }

    func testBadButtonBackground() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 2, height: 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()

        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(white: 0.96, alpha: 1), for: UIControlState())

        XCTAssertEqual(LUIInsufficientContrastReport.reports(button.titleLabel!).count, 1)
    }

    func testAcceptableButtonBackground() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 2, height: 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()

        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: UIControlState())
        button.setTitleColor(UIColor(white: 0.96, alpha: 1), for: UIControlState())

        XCTAssertEqual(LUIInsufficientContrastReport.reports(button).count, 0)
    }
}
