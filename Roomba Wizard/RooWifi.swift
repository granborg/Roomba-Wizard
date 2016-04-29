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
let BUMPWHEELDROPS_SENSOR         = 0
let WALL_SENSOR                   = 1
let CLIFFT_LEFT_SENSOR            = 2
let CLIFFT_FRONT_LEFT_SENSOR      = 3
let CLIFFT_FRONT_RIGHT_SENSOR     = 4
let CLIFFT_RIGHT_SENSOR           = 5
let VIRTUAL_WALL_SENSOR           = 6
let MOTOR_OVERCURRENTS_SENSOR     = 7
let DIRT_DETECTOR_LEFT_SENSOR     = 8
let DIRT_DETECTOR_RIGHT_SENSOR    = 9
let REMOTE_OPCODE_SENSOR          = 10
let BUTTONS_SENSOR                = 11
let DISTANCE_MSB_SENSOR           = 12
let DISTANCE_LSB_SENSOR           = 13
let ANGLE_MSB_SENSOR              = 14
let ANGLE_LSB_SENSOR              = 15
let CHARGING_STATE_SENSOR         = 16
let VOLTAGE_MSB_SENSOR            = 17
let VOLTAGE_LSB_SENSOR            = 18
let CURRENT_MSB_SENSOR            = 19
let CURRENT_LSB_SENSOR            = 20
let TEMPERATURE_SENSOR            = 21
let CHARGE_MSB_SENSOR             = 22
let CHARGE_LSB_SENSOR             = 23
let CAPACITY_MSB_SENSOR           = 24
let CAPACITY_LSB_SENSOR           = 25

//Battery Stringing States
let CHARGING_STATE_NO_CHARGING          = 0
let CHARGING_STATE_CHARGING_RECOVERY    = 1
let CHARGING_STATE_CHARGING             = 2
let CHARGING_STATE_TRICKLE_CHARGING     = 3
let CHARGING_STATE_WAITING              = 4
let CHARGING_STATE_CHARGING_ERROR       = 5

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
let COMMAND_MOTORS_PRECISE = 144
let COMMAND_WHEELS  = 145

//Number of parameters of Led commands
let LEDS_NUM_PARAMETERS         = 3

//Song Notes

//Note duration
let NOTE_DURATION_SIXTYFOURTH_NOTE  = 4
let NOTE_DURATION_THIRTYSECOND_NOTE = 8
let NOTE_DURATION_SIXTEENTH_NOTE    = 16
let NOTE_DURATION_EIGHTH_NOTE       = 32
let NOTE_DURATION_QUARTER_NOTE      = 64

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

func backgroundThread(delay: Double = 0.0, background: (() -> Void)? = nil, completion: (() -> Void)? = nil) {
    dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
        if(background != nil){ background!(); }
        
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(popTime, dispatch_get_main_queue()) {
            if(completion != nil){ completion!(); }
        }
    }
}

class RooWifi: NSObject {
    
    private var client:TCPClient = TCPClient(addr: "", port: 80)
    private var motors = 0
    private var sideBrushPower = 0 // 0 - 128
    private var vacuumPower = 0 // 0 - 128
    private var mainBrushPower = 0 // 0 - 128
    private var requestingData:Bool = false
    
    var batteryLevel:Double = 0.0

    class RoombaSensors {
        var BumpsWheeldrops:UInt8 = 0
        var Wall:UInt8 = 0
        var CliffLeft:UInt8 = 0
        var CliffFrontLeft:UInt8 = 0
        var CliffFrontRight:UInt8 = 0
        var CliffRight:UInt8 = 0
        var VirtualWall:UInt8 = 0
        var MotorOvercurrents:UInt8 = 0
        var DirtDetectorLeft:UInt8 = 0
        var DirtDetectorRight:UInt8 = 0
        var RemoteOpcode:UInt8 = 0
        var Buttons:UInt8 = 0
        var Distance:UInt16 = 0
        var Angle:UInt16 = 0
        var ChargingState:UInt8 = 0
        var Voltage:UInt16 = 0
        var Current:UInt16 = 0
        var Temperature:UInt8 = 0
        var Charge:UInt16 = 0
        var Capacity:UInt16 = 0
        init() {}
    }
    var sensors:RoombaSensors = RoombaSensors()

    init(ip: String, port: Int) {
        client = TCPClient(addr: ip, port: port)
        }
    
    deinit {
        self.requestingData = false
        let (success,errmsg) = client.close()
        if success {
            debug("Closed connection with Roomba")
        }
        else {
            debug("Close Error: \(errmsg)")
        }
    }
    
    func Start() -> Bool {
        var (success, errmsg) = client.close()
        if success {
            debug("Closed connection with Roomba")
        }
        else {
            debug(errmsg)
        }
        (success,errmsg) = client.connect(timeout:1)
        if success {
            debug("Established connection with Roomba")
            if (self.ExecuteCommand(COMMAND_START)) {
                if (self.requestingData) {
                    // There is already a thread requesting data, 
                    // so there is no need to spawn a new thread.
                    return true
                }
                backgroundThread(0.0, background: {
                    self.requestingData = true
                    while (self.requestingData) {
                        // Constantly refresh sensors
                        sleep(1)
                        self.RequestAllSensors()
                    }
                })
            }
            return true
        }
        debug("Connect Error: \(errmsg)")
        return false
    }
    
    func FullMode() -> Bool {
        return self.ExecuteCommand(COMMAND_FULL)
    }
    
    func SafeMode() -> Bool {
        return self.ExecuteCommand(COMMAND_SAFE)
    }

    func Drive(velocity: Int, radius: Int) -> Bool {
        if self.SafeMode() {
            // Drive can only be executed in safe or full mode.
            return self.ExecuteCommand(
                COMMAND_DRIVE,
                (velocity >> 8) & 0xFF,
                velocity & 0xFF,
                (radius >> 8) & 0xFF,
                radius & 0xFF)
        }
        return false
    }
    
    func Drive(right: Int, left: Int) -> Bool {
        if self.SafeMode() {
            // Drive can only be executed in safe or full mode.
            return self.ExecuteCommand(
                COMMAND_WHEELS,
                (right >> 8) & 0xFF,
                right & 0xFF,
                (left >> 8) & 0xFF,
                left & 0xFF)
        }
        return false
    }
    
    func Clean() -> Bool {
        return self.ExecuteCommand(COMMAND_CLEAN)
    }
    
    func Spot() -> Bool {
        return self.ExecuteCommand(COMMAND_SPOT)
    }
    
    func Dock() -> Bool {
        return self.ExecuteCommand(COMMAND_DOCK)
    }
    
    func StoreSong(songNumber: Int, notes: Song) -> Bool {
        self.ExecuteCommand(COMMAND_SONG, songNumber, notes.count)
        var sent = true
        for note in notes {
            if !self.ExecuteCommand(note.frequency, note.duration) {
                sent = false
            }
        }
        usleep(1000) // Allow time for storing song.
        return sent
    }
    
    func PlaySong(songNumber:Int) -> Bool {
        return self.ExecuteCommand(COMMAND_PLAY, songNumber)
    }
    
    func RequestAllSensors() -> Bool {
        if self.ExecuteCommand(COMMAND_SENSORS, 0) {
            self.requestingData = true
            if let newValues:[UInt8] = client.read(SCI_NUMBER_OF_SENSORS, timeout: 1) {
                //debug("Values to read: \(newValues.count), Expected: \(SCI_NUMBER_OF_SENSORS)")
                if newValues.count == SCI_NUMBER_OF_SENSORS {
                    self.UpdateSensors(newValues)
                    //print("Charge: \(self.batteryLevel)")
                    return true
                }
                debug("error: Couldn't gather all the data for sensors.")
            }
        } else {
            self.requestingData = false
        }
        return false
    }
    
    func UpdateSensors(newValues: [UInt8]) {
        //Update Sensor one by one
        self.sensors.BumpsWheeldrops = newValues[BUMPWHEELDROPS_SENSOR]
        self.sensors.Wall = newValues[WALL_SENSOR];
        self.sensors.CliffLeft = newValues[CLIFFT_LEFT_SENSOR];
        self.sensors.CliffFrontLeft = newValues[CLIFFT_FRONT_LEFT_SENSOR];
        self.sensors.CliffFrontRight = newValues[CLIFFT_FRONT_RIGHT_SENSOR];
        self.sensors.CliffRight = newValues[CLIFFT_RIGHT_SENSOR];
        self.sensors.VirtualWall = newValues[VIRTUAL_WALL_SENSOR];
        self.sensors.MotorOvercurrents = newValues[MOTOR_OVERCURRENTS_SENSOR];
        self.sensors.DirtDetectorLeft = newValues[DIRT_DETECTOR_LEFT_SENSOR];
        self.sensors.DirtDetectorRight = newValues[DIRT_DETECTOR_RIGHT_SENSOR];
        self.sensors.RemoteOpcode = newValues[REMOTE_OPCODE_SENSOR];
        self.sensors.Buttons = newValues[BUTTONS_SENSOR];
        
        self.sensors.Distance =  UInt16(newValues[DISTANCE_MSB_SENSOR]) << 8 | UInt16(newValues[DISTANCE_LSB_SENSOR])
        
        self.sensors.Angle = UInt16(newValues[ANGLE_MSB_SENSOR]) << 8 | UInt16(newValues[ANGLE_LSB_SENSOR])
        
        self.sensors.ChargingState = newValues[CHARGING_STATE_SENSOR]
        
        self.sensors.Voltage = UInt16(newValues[VOLTAGE_MSB_SENSOR]) << 8 | UInt16(newValues[VOLTAGE_LSB_SENSOR])
        
        self.sensors.Current = UInt16(newValues[CURRENT_MSB_SENSOR]) << 8 | UInt16(newValues[CURRENT_LSB_SENSOR])
        
        self.sensors.Temperature = newValues[TEMPERATURE_SENSOR]
        
        self.sensors.Charge = UInt16(newValues[CHARGE_MSB_SENSOR]) << 8 | UInt16(newValues[CHARGE_LSB_SENSOR])
        
        self.sensors.Capacity =  UInt16(newValues[CAPACITY_MSB_SENSOR]) << 8 |
            UInt16(newValues[CAPACITY_LSB_SENSOR])
        //Class values
        self.batteryLevel =  Double(self.sensors.Charge) / Double(self.sensors.Capacity)
    }
    
    func Vacuum_On() -> Bool {
        self.motors |= VACUUM_ON
        return self.UpdateMotors()
    }
    
    func Vacuum_Off() -> Bool{
        self.motors &= VACUUM_OFF
        return self.UpdateMotors()
    }
    
    func SideBrush_On() -> Bool{
        self.motors |= SIDE_BRUSH_ON
        return self.UpdateMotors();
    }

    func SideBrush_Off() -> Bool {
        self.motors &= SIDE_BRUSH_OFF
        return self.UpdateMotors();
    }
    
    func AllCleaningMotors_On() -> Bool {
        self.motors |= ALL_CLEANING_MOTORS_ON
        return self.UpdateMotors()
    }
    
    func AllCleaningMotors_Off() -> Bool {
        self.motors &= ALL_CLEANING_MOTORS_OFF
        return self.UpdateMotors()
    }
    
    func UpdateMotors() -> Bool {
        if self.SafeMode() {
            return self.ExecuteCommand(COMMAND_MOTORS, self.motors)
        }
        return false
    }
    
    func sideBrushPercent (percent: Double) {
        self.sideBrushPower = Int(percent * 128)
    }
    
    func vacuumPercent(percent: Double) {
        self.vacuumPower = Int(percent * 128)
    }
    
    func mainBrushPercent (percent: Double) {
        self.mainBrushPower = Int(percent * 128)
    }
    
    func UpdateMotorsPrecise() -> Bool {
        if self.SafeMode() {
            return self.ExecuteCommand(COMMAND_MOTORS_PRECISE, self.mainBrushPower, self.sideBrushPower, self.vacuumPower)
        }
        return false
    }
    
    private func ExecuteCommand(commands: Int...) -> Bool {
        return self.ExecuteCommand(commands)
    }
    
    private func ExecuteCommand(commands: [Int]) ->Bool {
        var sent = false
        dispatch_sync(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
            //Do something else
            for command in commands {
                // We only send the first 8 bytes of each command and parameter.
                var commandToSend = command & 0xFF
                let (success,errmsg) =
                    self.client.send(data: NSData(bytes: &commandToSend, length:sizeof(Int8)))
                if success {
                    debug("Successfully sent command: \(commandToSend)")
                    sent = true
                }
                else {
                    debug("Send Error: \(errmsg)")
                    break;
                }
            }
        }
        return sent
    }
}
