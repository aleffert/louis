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
    
    private func imageWithColor(_ color: UIColor = UIColor.white) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 2, height: 2))
        let image = UIGraphicsGetImageFromCurrentImageContext()!.withRenderingMode(.alwaysTemplate)
        UIGraphicsEndImageContext()
        return image
    }
    
    func testLabelTextOnSimilarBackground() {
        // Case: Text and background are insufficiently different
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.black
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 1)
    }

    func testDifferentBackgroundNoReport() {
        // Case: Text and background are sufficiently different
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.text = "Test"

        let reports = LUIInsufficientContrastReport.reports(label)
        XCTAssertEqual(reports.count, 0)
    }

    func testDifferentParentBackground() {
        // Case: Text and parent background are sufficiently different
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
        // Case: Label with no background is fine
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "Test"

        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }

    func testImageTint() {
        // Case: Image with tint and background lack contrast
        let image = imageWithColor()

        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.white.withAlphaComponent(0.8)

        let container = UIView()
        container.backgroundColor = offWhite
        container.addSubview(imageView)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(imageView).count, 1)
    }

    func testBadButtonBackground() {
        // Case: Button title and background image lack sufficient contrast
        let image = imageWithColor()

        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.setTitleColor(offWhite, for: .normal)

        XCTAssertEqual(LUIInsufficientContrastReport.reports(button.titleLabel!).count, 1)
    }
    
    func testContainingLowerSiblingExamined() {
        // Case: Sibling lower in the z order can effectively be a background
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
        sibling.frame = CGRect(x: 24, y:6, width: 127, height: 26.5)
        label.frame = CGRect(x: 30, y: 12, width: 115, height: 14.5)
        
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 1)
        
        // Ensure lower sibling does *not* contain test view
        label.frame = CGRect(x: 125, y: 125, width: 50, height: 50)
        
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }
    
    func testContainingUpperSiblingUnexamined() {
        // Case: Sibling lower in the z order can effectively be a background
        // But only relevant when the geometry overlaps
        
        // Setup
        let container = UIView()
        let sibling = UIView()
        sibling.backgroundColor = UIColor.white
        let label = UILabel()
        label.text = "Example"
        label.textColor = offWhite
        
        container.addSubview(label)
        container.addSubview(sibling)
        
        // Ensure higher sibling geometry contains test view
        sibling.frame = CGRect(x: 0, y:0, width: 100, height: 100)
        label.frame = CGRect(x: 25, y: 25, width: 50, height: 50)
        
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
        
        // Ensure higher sibling does *not* contain test view
        label.frame = CGRect(x: 125, y: 125, width: 50, height: 50)
        
        XCTAssertEqual(LUIInsufficientContrastReport.reports(label).count, 0)
    }
    
    func testButtonBackgroundIgnoredWhenBackgroundImageOpaque() {
        // Case: When a button has a backgroundImage, we don't want the backgroundColor
        // to matter if and only if the backgroundImage is opaque
        // You could also just not have a backgroundColor in this case probably,
        // but we found this in the wild.
        
        let image = imageWithColor()
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(image, for: .normal)
        
        for subview in button.subviews {
            XCTAssertEqual(LUIInsufficientContrastReport.reports(subview).count, 0);
        }
    }
    
    func testNavigationBarButton() {
        // Case: These are template images from context, but not explicitly,
        // so make sure they respect the tintColor not the underlying image color
        // based on the button image
        
        let bar = UINavigationBar()
        bar.tintColor = UIColor.black
        bar.barTintColor = UIColor.white
        
        let image = imageWithColor(UIColor.white.withAlphaComponent(0.8)).withRenderingMode(.automatic)
        let buttonItem = UIBarButtonItem(image:image, style:.plain, target: nil, action:nil)
        let navigationItem = UINavigationItem()
        navigationItem.leftBarButtonItem = buttonItem
        bar.pushItem(navigationItem, animated: false)
        
        bar.layoutIfNeeded()
        
        XCTAssertEqual(bar.subviews[1].subviews[0].lui_accessibility_reports(recursive: true, reporters: [LUIInsufficientContrastReport.self]).count, 0);
    }
    
    func testButtonBackgroundNotIgnoredWhenBackgroundImageNotOpaque() {
        // Case: When a button has a backgroundImage, we don't want the backgroundColor
        // to matter if and only if the backgroundImage is opaque
        // You could also just not have a backgroundColor in this case probably,
        // but we found this in the wild.
        
        let image = imageWithColor(UIColor.white.withAlphaComponent(0.8))
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.setBackgroundImage(image, for: .normal)
        
        for subview in button.subviews {
            XCTAssertEqual(LUIInsufficientContrastReport.reports(subview).count, 1);
        }
    }
    
}
