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
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func Db(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 49, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Eb(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 51, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Gb(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 54, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Ab(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 56, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Bb(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 58, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func C(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 48, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func D(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 50, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func E(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 52, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func F(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 53, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func G(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 55, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func A(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 57, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func B(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 59, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Db2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 61, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Eb2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 63, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Gb2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 66, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Ab2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 68, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func Bb2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 70, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func C2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 60, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func D2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 62, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func E2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 64, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func F2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 65, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func G2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 67, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func A2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 69, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
    }
    @IBAction func B2(sender: AnyObject) {
        if rooWifi.StoreSong(0, notes:[(frequency: 71, duration : NOTE_DURATION_THIRTYSECOND_NOTE)]) {
            rooWifi.PlaySong(0)
        }
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
             (frequency: 72, duration:8)]
        rooWifi.StoreSong(2, notes: newStartUp)
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
             (frequency: 77, duration:8),
             (frequency: 79, duration:8),
             (frequency: 79, duration:8),
             (frequency: 79, duration:8),
             (frequency: 79, duration:8),
             (frequency: 80, duration:8),
             (frequency: 80, duration:8),
             (frequency: 77, duration:8),
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
            (frequency: 87, duration:NOTE_DURATION_EIGHTH_NOTE),
            (frequency: 89, duration:NOTE_DURATION_QUARTER_NOTE),
            (frequency: 83, duration:NOTE_DURATION_QUARTER_NOTE),
        ]
        rooWifi.StoreSong(4, notes: HarryPotter)
        rooWifi.PlaySong(4)
    }

}