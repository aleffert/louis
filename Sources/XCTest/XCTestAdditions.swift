//
//  XCTestAdditions.swift
//  Louis
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

import UIKit

import XCTest

func LUIAssertAccessible(view : UIView, file: String = __FILE__, line: UInt = __LINE__) {
    let reports = view.lui_accessibilityReports()
    let message = "Accessibility Error:\n" + reports.map { (report) in
        return "[\(report.dynamicType)] \(report.message)"
    }.joinWithSeparator("\n")
    XCTAssertEqual(reports.count, 0, message, file: file, line: line)
}
