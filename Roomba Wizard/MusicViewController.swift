//
//  MusicViewController.swift
//  Roomba Wizard
//
//  Created by Nick Nguyen on 4/15/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import Foundation
import UIKit

class MusicViewController: UIViewController {
   
    
  //  var rooWifi = RooWifi(ip:"10.0.0.1", port:9001)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Song1(sender: AnyObject) {
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
        rooWifi.StoreSong(1, notes: zelda)
        rooWifi.PlaySong(1)
    }
    @IBAction func Song2(sender: AnyObject) {
        let newStartUp:Song =
            [(frequency: 67, duration:8),
             (frequency: 66, duration:8),
             (frequency: 63, duration:8),
             (frequency: 57, duration:8),
             (frequency: 56, duration:8),
             (frequency: 64, duration:8),
             (frequency: 68, duration:8),
             (frequency: 72, duration:8),
             ]
        rooWifi.StoreSong(2, notes: newStartUp)
        rooWifi.PlaySong(2)
    }
    @IBAction func Song3(sender: AnyObject) {
        let Animals:Song =
            [(frequency: 80, duration:16),
            (frequency: 80, duration: 16),
            (frequency: 82, duration: 16),
            (frequency: 84, duration: 16),
            (frequency: 87, duration: 16),
            (frequency: 82, duration: 8),
            (frequency: 82, duration: 8),
            (frequency: 80, duration: 8),
            (frequency: 79, duration: 8),
            (frequency: 77, duration: 8),
            (frequency: 79, duration: 8),
            (frequency: 79, duration: 8),
            (frequency: 80, duration: 16),
            (frequency: 80, duration: 16),
         /*   (frequency: 77, duration:8),
            (frequency: 79, duration:8),
            (frequency: 79, duration:8),
            (frequency: 79, duration:8),
            (frequency: 79, duration:8),
            (frequency: 80, duration:8),
            (frequency: 80, duration:8),
            (frequency: 77, duration:8),*/
            ]
        rooWifi.StoreSong(3, notes: Animals)
        rooWifi.PlaySong(3)
       
    }
    
    @IBAction func Song4(sender: AnyObject) {
        let HarryPotter:Song =
            [(frequency: 83, duration:NOTE_DURATION_SIXTEENTH_NOTE),
            (frequency: 88, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 91, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 90, duration:NOTE_DURATION_SIXTEENTH_NOTE),
            (frequency: 88, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 95, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 93, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 90, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 88, duration:NOTE_DURATION_SIXTEENTH_NOTE),
            (frequency: 91, duration:NOTE_DURATION_SIXTEENTH_NOTE),
            (frequency: 90, duration:NOTE_DURATION_EIGHTH_NOTE),
  /*          (frequency: 87, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 89, duration:NOTE_DURATION_QUARTER_NOTE),
            (frequency: 83, duration:NOTE_DURATION_QUARTER_NOTE),*/
        ]
        rooWifi.StoreSong(4, notes: HarryPotter)
        rooWifi.PlaySong(4)
    }

}