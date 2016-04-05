//
//  ViewController.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rooWifi = RooWifi(ip:"10.0.0.1", port:9001)
        rooWifi.Start()
        rooWifi.FullMode()
        rooWifi.Drive(-200, radius: 0)
        sleep(3)
        rooWifi.Drive(0, radius: 0)
        rooWifi.SafeMode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

