//
//  ViewController.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

//  Useful links: 
//        http://www.irobot.com/filelibrary/pdfs/hrd/create/Create%20Open%20Interface_v2.pdf

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rooWifi = RooWifi(ip:"10.0.0.1", port:9001)
        rooWifi.Start()
        rooWifi.FullMode()
        

        let notes:Song =
                [(frequency: 60, duration:NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 62, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 64, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 67, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 65, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 64, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 62, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 59, duration: NOTE_DURATION_EIGHTH_NOTE),
                 (frequency: 60, duration: NOTE_DURATION_EIGHTH_NOTE)]
        
        rooWifi.StoreSong(0, notes: notes)
        rooWifi.PlaySong(0)
        rooWifi.Drive(0xFF38, radius: 0xFFFF) // spin left
        sleep(3)
        rooWifi.Drive(0xFF38, radius: 0x0001) // spin right
        sleep(3)
        rooWifi.Drive(0, radius: 0)
        sleep(10)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

