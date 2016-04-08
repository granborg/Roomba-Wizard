//
//  ViewController.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var rooWifi = RooWifi(ip:"10.0.0.1", port:9001)
    var velocity = 0
    var radius = 0
    
    @IBAction func ForwardDown(sender: AnyObject) {
        velocity = 500
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
        velocity = -500
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
            radius = 1000
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
            radius = -1000
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
        // Do any additional setup after loading the view, typically from a nib.
        
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
        //rooWifi.PlaySong(0)
        //sleep(10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

