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

    
    @IBOutlet weak var controlView: SKView!
    var scene:ControlScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scene = ControlScene(size: controlView.bounds.size, rooWifi: &rooWifi)
        controlView.multipleTouchEnabled = true
        controlView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        var text=""
        scene!.AdjustOrientation()
        switch UIDevice.currentDevice().orientation{
        case .Portrait:
            text="Portrait"
        case .PortraitUpsideDown:
            text="PortraitUpsideDown"
        case .LandscapeLeft:
            text="LandscapeLeft"
        case .LandscapeRight:
            text="LandscapeRight"
        default:
            text="Another"
        }
        debug("You have moved: \(text)")
    }
}

