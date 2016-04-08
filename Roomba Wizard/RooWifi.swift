//
//  RooWifi.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//
//  Useful links:
//        http://www.irobot.com/filelibrary/pdfs/hrd/create/Create%20Open%20Interface_v2.pdf

import UIKit
import Foundation

//Number of sensors in SCI specification
let SCI_NUMBER_OF_SENSORS = 26

//Byte postion for each sensor in response frame
let BUMPWHEELDROPS_SENSOR       = 0
let WALL_SENSOR                 = 1
let CLIFFT_LEFT_SENSOR          = 2
let CLIFFT_FRONT_LEFT_SENSOR    = 3
let CLIFFT_FRONT_RIGHT_SENSOR   = 4
let CLIFFT_RIGHT_SENSOR         = 5
let VIRTUAL_WALL_SENSOR         = 6
let MOTOR_OVERCURRENTS_SENSOR   = 7
let DIRT_DETECTOR_LEFT_SENSOR   = 8
let DIRT_DETECTOR_RIGHT_SENSOR  = 9
let REMOTE_OPCODE_SENSOR        = 10
let BUTTONS_SENSOR              = 11
let DISTANCE_MSB_SENSOR         = 12
let DISTANCE_LSB_SENSOR         = 13
let ANGLE_MSB_SENSOR            = 14
let ANGLE_LSB_SENSOR            = 15
let StringGING_STATE_SENSOR     = 16
let VOLTAGE_MSB_SENSOR          = 17
let VOLTAGE_LSB_SENSOR          = 18
let CURRENT_MSB_SENSOR          = 19
let CURRENT_LSB_SENSOR          = 20
let TEMPERATURE_SENSOR          = 21
let StringGE_MSB_SENSOR         = 22
let StringGE_LSB_SENSOR         = 23
let CAPACITY_MSB_SENSOR         = 24
let CAPACITY_LSB_SENSOR         = 25

//Battery Stringing States
let StringGING_STATE_NO_StringGING          = 0
let StringGING_STATE_StringGING_RECOVERY    = 1
let StringGING_STATE_StringGING             = 2
let StringGING_STATE_TRICKLE_CHAGING      = 3
let StringGING_STATE_WAITING              = 4
let StringGING_STATE_StringGING_ERROR       = 5

//Commands
let COMMAND_START   = 128
let COMMAND_SAFE    = 131
let COMMAND_FULL    = 132
let COMMAND_POWER   = 133
let COMMAND_SPOT    = 134
let COMMAND_CLEAN   = 135
let COMMAND_MAX     = 136
let COMMAND_DRIVE   = 137
let COMMAND_MOTORS  = 138
let COMMAND_LEDS    = 139
let COMMAND_SONG    = 140
let COMMAND_PLAY    = 141
let COMMAND_SENSORS = 142
let COMMAND_DOCK    = 143

//Number of parameters of Led commands
let LEDS_NUM_PARAMETERS         = 3

//Song Notes
 

//Note duration
///British names
let NOTE_DURATION_SEMIQUAVER        = 16      //semicorchea
let NOTE_DURATION_QUAVER            = 32      //corchea
let NOTE_DURATION_CROTCHET          = 64      //negra
///US names
let NOTE_DURATION_SIXTEENTH_NOTE    = NOTE_DURATION_SEMIQUAVER
let NOTE_DURATION_EIGHTH_NOTE       = NOTE_DURATION_QUAVER
let NOTE_DURATION_QUARTER_NOTE      = NOTE_DURATION_CROTCHET

 
//Led Control MASKS
let LED_CLEAN_ON                = 0x04
let LED_CLEAN_OFF               = 0xFB
let LED_SPOT_ON                 = 0x08
let LED_SPOT_OFF                = 0xF7
let LED_DIRT_ON                 = 0x01
let LED_DIRT_OFF                = 0xFE
let LED_MAX_ON                  = 0x02
let LED_MAX_OFF                 = 0xFD
let LED_STATUS_OFF              = 0x0F
let LED_STATUS_AMBAR            = 0x30
let LED_STATUS_RED              = 0x10
let LED_STATUS_GREEN            = 0x20

//Cleaning Motors Control MASKS
let SIDE_BRUSH_ON               = 0x01
let SIDE_BRUSH_OFF              = 0xFE
let VACUUM_ON                   = 0x02
let VACUUM_OFF                  = 0xFD
let MAIN_BRUSH_ON               = 0x04
let MAIN_BRUSH_OFF              = 0xFB
let ALL_CLEANING_MOTORS_ON      = 0xFF
let ALL_CLEANING_MOTORS_OFF     = 0x00

typealias Song = [(frequency: Int, duration: Int)]

func debug(s: String) -> Void {
    let debug = true
    if (debug) {
        print(s)
    }
}

class RooWifi: NSObject {
    
    var client:TCPClient = TCPClient(addr: "", port: 80)

    init(ip: String, port: Int) {
        client = TCPClient(addr: ip, port: port)
        }
    
    deinit {
        let (success,errmsg) = client.close()
        if success {
            debug("Closed connection with Roomba")
        }
        else {
            debug("Close Error: \(errmsg)")
        }
    }
    
    func Start() {
        let (success,errmsg) = client.connect(timeout: 2)
        if success {
            debug("Established connection with Roomba")
            self.ExecuteCommand(COMMAND_START)
        }
        else {
            debug("Connect Error: \(errmsg)")
        }
    }
    
    func FullMode() {
        self.ExecuteCommand(COMMAND_FULL)
    }
    
    func SafeMode() {
        self.ExecuteCommand(COMMAND_SAFE)
    }

    func Drive(velocity: Int, radius: Int) {
        self.ExecuteCommand(
            COMMAND_DRIVE,
            (velocity >> 8) & 0xFF,
            velocity & 0xFF,
            (radius >> 8) & 0xFF,
            radius & 0xFF)
    }
    
    func Dock() {
        self.ExecuteCommand(COMMAND_DOCK)
    }
    
    func StoreSong(songNumber: Int, notes: Song) {
        self.ExecuteCommand(COMMAND_SONG, songNumber, notes.count)
        
        for note in notes {
            self.ExecuteCommand(note.frequency, note.duration)
        }
        usleep(1000) // Allow time for storing song.
    }
    
    func PlaySong(songNumber:Int) {
        self.ExecuteCommand(COMMAND_PLAY, songNumber)
    }
    
    private func ExecuteCommand(commands: Int...) {
        self.ExecuteCommand(commands)
    }
    
    private func ExecuteCommand(commands: [Int]) {
        
        for command in commands {
            // We only send the first 8 bytes of each command and parameter.
            var commandToSend = command & 0xFF
            let (success,errmsg) =
                client.send(data: NSData(bytes: &commandToSend, length:sizeof(Int8)))
            if success {
                debug("Successfully sent command: \(commandToSend)")
            }
            else {
                debug("Send Error: \(errmsg)")
            }
        }
    }
}
