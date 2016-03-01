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
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor.blackColor()
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 1)
    }

    func testDifferentBackgroundNoReport() {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor.blackColor()
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 0)
    }

    func testDifferentParentBackground() {
        let container = UIView()
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.text = "Test"
        container.backgroundColor = UIColor.blackColor()
        container.addSubview(label)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)

        // Now swap and make sure we get the same result
        label.textColor = UIColor.blackColor()
        container.backgroundColor = UIColor.whiteColor()

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testNoBackground() {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.text = "Test"

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testImageTint() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), true, 0)
        let image = UIGraphicsGetImageFromCurrentImageContext().imageWithRenderingMode(.AlwaysTemplate)
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.whiteColor()

        let container = UIView()
        container.backgroundColor = UIColor(white: 0.96, alpha: 1)
        container.addSubview(imageView)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(imageView).count, 1)
    }
}
