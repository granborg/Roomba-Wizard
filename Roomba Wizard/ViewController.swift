//
//  ViewController.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import UIKit
import SpriteKit
var rooWifi = RooWifi(ip:"10.0.0.1", port:9001)

class ViewController: UIViewController {
    

    @IBOutlet weak var ControlView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = ControlScene(size: ControlView.bounds.size, rooWifi: &rooWifi)
        let skView = self.ControlView as! SKView
        skView.multipleTouchEnabled = true
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

