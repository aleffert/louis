//
//  ViewController.swift
//  Example
//
//  Created by Akiva Leffert on 3/1/16.
//  Copyright © 2016 Akiva Leffert. All rights reserved.
//

import UIKit
import Louis

class ViewController: UIViewController {

    @IBAction func activate(sender: UIButton) {
        LUILouis.shared().reportAction = { LUIAssertionLogger($0) }
        LUILouis.shared().timedCheckEnabled = true
    }


}

