//
//  RooWifi.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/1/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import UIKit
import Foundation
/*
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
let CHARGING_STATE_SENSOR       = 16
let VOLTAGE_MSB_SENSOR          = 17
let VOLTAGE_LSB_SENSOR          = 18
let CURRENT_MSB_SENSOR          = 19
let CURRENT_LSB_SENSOR          = 20
let TEMPERATURE_SENSOR          = 21
let CHARGE_MSB_SENSOR           = 22
let CHARGE_LSB_SENSOR           = 23
let CAPACITY_MSB_SENSOR         = 24
let CAPACITY_LSB_SENSOR         = 25

//Battery Charging States
let CHARGING_STATE_NO_CHARGING          = 0
let CHARGING_STATE_CHARGING_RECOVERY    = 1
let CHARGING_STATE_CHARGING             = 2
let CHARGING_STATE_TRICKLE_CHAGING      = 3
let CHARGING_STATE_WAITING              = 4
let CHARGING_STATE_CHARGING_ERROR       = 5
*/
//Commands
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
/*
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

class RooWifi: NSObject {

    class RoombaSensors {
        var BumpsWheeldrops: Char?
        var Wall: Char?
        var CliffLeft: Char?
        var CliffFrontLeft: Char?
        var CliffFrontRight: Char?
        var CliffRight: Char?
        var VirtualWall: char?
        var MotorOvercurrents?
        var DirtDetectorLeft?
        var DirtDetectorRight?
        var RemoteOpcode?
        var Buttons?
        var Distance: CShort?
        var Angle: CShort?
        var ChargingState?
        var Voltage?
        var Current?
        var Temperature?
        unsigned short Charge?
        unsigned short Capacity?
        
        func Init() {
            
        }
    }
    
    ////////////////
    //INIT FUNCTIONS
    ////////////////
    
    //
    // RooWifi::InitGatewayTCPIP
    //
    func InitGatewayTCPIP() -> void {
    qstIP = DEFAULT_ROOWIFI_IP;
    TCPPort = ROOWIFI_GATEWAY_PORT;
    tcpSocket = new QTcpSocket ( this );
    }
    
    //
    // RooWifi::InitSensors
    //
    void RooWifi::InitSensors()
    {
    Sensors.BumpsWheeldrops = ZERO_BY_DEFAULT;
    Sensors.Wall = ZERO_BY_DEFAULT;
    Sensors.CliffLeft = ZERO_BY_DEFAULT;
    Sensors.CliffFrontLeft = ZERO_BY_DEFAULT;
    Sensors.CliffFrontRight = ZERO_BY_DEFAULT;
    Sensors.CliffRight = ZERO_BY_DEFAULT;
    Sensors.VirtualWall = ZERO_BY_DEFAULT;
    Sensors.MotorOvercurrents = ZERO_BY_DEFAULT;
    Sensors.DirtDetectorLeft = ZERO_BY_DEFAULT;
    Sensors.DirtDetectorRight = ZERO_BY_DEFAULT;
    Sensors.RemoteOpcode = ZERO_BY_DEFAULT;
    Sensors.Buttons = ZERO_BY_DEFAULT;
    Sensors.Distance = ZERO_BY_DEFAULT;
    Sensors.Angle = ZERO_BY_DEFAULT;
    Sensors.ChargingState = ZERO_BY_DEFAULT;
    Sensors.Voltage = ZERO_BY_DEFAULT;
    Sensors.Current = ZERO_BY_DEFAULT;
    Sensors.Temperature = ZERO_BY_DEFAULT;
    Sensors.Charge = ZERO_BY_DEFAULT;
    Sensors.Capacity = ZERO_BY_DEFAULT;
    }
    
    //
    // RooWifi::InitLeds
    //
    void RooWifi::InitLeds()
    {
    int Counter;
    
    for( Counter = 0; Counter < LEDS_NUM_PARAMETERS; Counter++ )
    Leds[Counter] = ZERO_BY_DEFAULT;
    }
    
    //
    // RooWifi::InitMotors
    //
    void RooWifi::InitMotors()
    {
    Motors = ZERO_BY_DEFAULT;
    }
    
    //
    // RooWifi::InitAutoCapture
    //
    void RooWifi::InitAutoCapture()
    {
    BatteryLevel = ZERO_BY_DEFAULT;
    CaptureTime = AUTO_CAPTURE_DEFAULT_PERIOD;
    AutoCaptureTimer = new QTimer( this );
    }
*/

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
        let (success,errmsg) = client.connect(timeout: 1)
        if success {
            debug("Established connection with Roomba")
            sleep(5)
        }
        else {
            debug("Connect Error: \(errmsg)")
        }
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
    
    func FullMode() {
        self.ExecuteCommand(COMMAND_FULL)
    }
    
    func SafeMode() {
        self.ExecuteCommand(COMMAND_SAFE)
    }

    func Drive(velocity: Int, radius: Int) {
        self.ExecuteCommand(
            COMMAND_DRIVE,
            velocity >> 8,
            velocity,
            radius >> 8,
            radius)
    }
    
    func Dock() {
        self.ExecuteCommand(COMMAND_DOCK)
    }
    
    private func ExecuteCommand(commands: Int...) {
        
        for command in commands {
            // We only send the first 8 bytes of each command and parameter.
            var commandToSend = command & 0xFF
            let (success,errmsg) =
                client.send(data: NSData(bytes: &commandToSend, length:sizeof(Int8)))
            if success {
                debug("Successfully sent command: \(command)")
            }
            else {
                debug("Send Error: \(errmsg)")
            }
        }
    }
}
