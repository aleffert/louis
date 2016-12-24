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
    
    private var offWhite: UIColor {
        return UIColor(white: 0.96, alpha: 1)
    }
    
    
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
        container.backgroundColor = offWhite
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
        button.setBackgroundImage(image, for: .normal)
        button.setTitleColor(offWhite, for: .normal)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(button.titleLabel!).count, 1)
    }
    
    func testContainingLowerSiblingExamined() {
        // Siblings are lower in the z order so they can count as backgrounds.
        // But only relevant when the geometry overlaps
        
        // Setup
        let container = UIView()
        let sibling = UIView()
        sibling.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "Example"
        label.textColor = offWhite
        
        container.addSubview(sibling)
        container.addSubview(label)
        
        // Ensure lower sibling geometry contains test view
        sibling.frame = CGRect(x: 0, y:0, width: 100, height: 100)
        label.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 1)
        
        // Ensure lower sibling does *not* contain test view
        label.frame = CGRect(x: 125, y: 125, width: 50, height: 50)
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testAcceptableButtonBackground() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 2, height: 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()

        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.setTitleColor(UIColor(white: 0.96, alpha: 1), for: .normal)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(button).count, 0)
    }
}
