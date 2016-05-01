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
        let A_fourth:Song =
            [(frequency: 69, duration : NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(1, notes:A_fourth)
        usleep(15000)
        let B_fourth:Song = [(frequency: 71, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(2, notes:B_fourth)
        usleep(15000)
        let C_fourth:Song = [(frequency: 72, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(3, notes:C_fourth)
        usleep(15000)
        let D_fourth:Song = [(frequency: 74, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(4, notes:D_fourth)
        usleep(15000)
        let E_fourth:Song = [(frequency: 76, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(5, notes:E_fourth)
        usleep(15000)
        let F_fourth:Song = [(frequency: 77, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(6, notes:F_fourth)
        usleep(15000)
        let G_fourth:Song = [(frequency: 72, duration: NOTE_DURATION_QUARTER_NOTE)]
        rooWifi.StoreSong(7, notes:G_fourth)
        usleep(15000)
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
        rooWifi.StoreSong(8, notes: zelda)
        usleep(15000)
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
        rooWifi.StoreSong(9, notes: newStartUp)
        super.viewDidLoad()
    }
    
    @IBAction func A_fourth(sender: AnyObject) {
        rooWifi.PlaySong(1);
    }
    
    @IBAction func B_fourth(sender: AnyObject) {
        rooWifi.PlaySong(2);
    }
    
    @IBAction func C_fourth(sender: AnyObject) {
        rooWifi.PlaySong(3);
    }
    
    @IBAction func D_fourth(sender: AnyObject) {
        rooWifi.PlaySong(4);
    }
    
    @IBAction func E_fourth(sender: AnyObject) {
        rooWifi.PlaySong(5);
    }
    
    @IBAction func F_fourth(sender: AnyObject) {
        rooWifi.PlaySong(6);
    }
    
    @IBAction func G_fourth(sender: AnyObject) {
        rooWifi.PlaySong(7);
    }
    
    @IBAction func Song1(sender: AnyObject) {
        rooWifi.PlaySong(8)
    }
    @IBAction func Song2(sender: AnyObject) {
        rooWifi.PlaySong(9)
    }
    
    
    @IBAction func A_eighth(sender: AnyObject) {
    }
    
    
    @IBAction func b_eighth(sender: AnyObject) {
    }
    
    
    @IBAction func C_eighth(sender: AnyObject) {
    }
    
    
    @IBAction func D_eighth(sender: AnyObject) {
    }
    
    @IBAction func E_eighth(sender: AnyObject) {
    }
    
    @IBAction func F_eighth(sender: AnyObject) {
    }
    
    @IBAction func G_eighth(sender: AnyObject) {
    }
    
    @IBAction func A_sixteenth(sender: AnyObject) {
    }
    
    @IBAction func B_sixteenth(sender: AnyObject) {
    }
    
    @IBAction func C_sixteenth(sender: AnyObject) {
    }
    
    @IBAction func D_Sixteenth(sender: AnyObject) {
    }
   
    @IBAction func E_sixteenth(sender: AnyObject) {
    }
    
    @IBAction func F_Sixteenth(sender: AnyObject) {
    }
    
    @IBAction func G_sixteenth(sender: AnyObject) {
    }
    
    
    
    
    
    /*
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
    }*/

}