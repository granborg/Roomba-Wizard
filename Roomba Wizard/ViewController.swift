//
//  ViewController.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    

    @IBOutlet weak var AnalogView: UIView!
    
    var rooWifi = RooWifi(ip:"10.0.0.1", port:9001)
    var velocity = 0
    var radius = 0
    enum Automation {
        case None
        case Clean
        case Spot
        case Dock
    }
    var auto = Automation.None
    
    @IBAction func Clean(sender: AnyObject) {
        if (auto == .Clean) {
            rooWifi.SafeMode()
            auto = .None
        }
        else {
            rooWifi.Clean()
            auto = .Clean
        }
    }
    @IBAction func Spot(sender: AnyObject) {
        if (auto == .Spot) {
            rooWifi.SafeMode()
            auto = .None
        }
        else {
            rooWifi.Spot()
            auto = .Spot
        }
    }
    @IBAction func Dock(sender: AnyObject) {
        if (auto == .Dock) {
            rooWifi.SafeMode()
            auto = .None
        }
        else {
            rooWifi.Dock()
            auto = .Dock
        }
    }
    @IBAction func Motors(sender: AnyObject) {
        if (rooWifi.motors == 0) {
            rooWifi.AllCleaningMotors_On()
        }
        else {
            rooWifi.AllCleaningMotors_Off()
        }
    }
    @IBAction func Connect(sender: AnyObject) {
        
        rooWifi.Start()
        rooWifi.SafeMode()
        
        // Zelda
        let zelda:Song =
            [(frequency: 53, duration:NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 57, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 59, duration: NOTE_DURATION_EIGHTH_NOTE),
             (frequency: 53, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 57, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 59, duration: NOTE_DURATION_EIGHTH_NOTE),
             (frequency: 53, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 57, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 59, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 64, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 62, duration: NOTE_DURATION_EIGHTH_NOTE),
             (frequency: 59, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 60, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 59, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 55, duration: NOTE_DURATION_SIXTEENTH_NOTE),
             (frequency: 52, duration: NOTE_DURATION_QUARTER_NOTE)]
        
        rooWifi.StoreSong(0, notes: zelda)
        rooWifi.PlaySong(0)
    }
    @IBAction func ForwardDown(sender: AnyObject) {
        velocity = 300
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func ForwardUp(sender: AnyObject) {
        velocity = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func ForwardUpOutside(sender: AnyObject) {
        velocity = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    
    @IBAction func BackwardDown(sender: AnyObject) {
        velocity = -300
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func BackwardUp(sender: AnyObject) {
        velocity = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func BackwardUpOutside(sender: AnyObject) {
        velocity = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    
    @IBAction func RightDown(sender: AnyObject) {
        if (velocity == 0) {
            rooWifi.Drive(0xFF38, radius: 0x0001) // spin right
        } else {
            radius = -2000
            rooWifi.Drive(velocity, radius: radius)
        }
    }
    @IBAction func RightUp(sender: AnyObject) {
        radius = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func RightUpOutside(sender: AnyObject) {
        radius = 0
        rooWifi.Drive(velocity, radius: radius)
    }

    
    
    @IBAction func LeftDown(sender: AnyObject) {
        if (velocity == 0) {
            rooWifi.Drive(0xFF38, radius: 0xFFFF) // spin left
        } else {
            radius = 2000
            rooWifi.Drive(velocity, radius: radius)
        }
    }
    @IBAction func LeftUp(sender: AnyObject) {
        radius = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    @IBAction func LeftUpOutside(sender: AnyObject) {
        radius = 0
        rooWifi.Drive(velocity, radius: radius)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = AnalogStick(size: view.bounds.size, rooWifi: &self.rooWifi)
        let skView = self.AnalogView as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

