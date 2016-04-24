//
//  AnalogStick.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/10/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import SpriteKit

class ControlScene: SKScene {
    
    enum Automation {
        case None
        case Clean
        case Spot
        case Dock
    }

    struct Colors {
        let Off = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        let On = UIColor(red: 0, green: 255, blue: 0, alpha: 1.0)
    }
    let ControlColors = Colors()
    
    let arrow = SKSpriteNode(imageNamed: "Arrow")
    let clean = SKSpriteNode(imageNamed: "Clean")
    let compass = SKSpriteNode(imageNamed: "Compass")
    let connect = SKSpriteNode(imageNamed: "Connect")
    let dock = SKSpriteNode(imageNamed: "Dock")
    let motor = SKSpriteNode(imageNamed: "Motor")
    let leftBase = SKSpriteNode(imageNamed: "Base")
    let leftSlider = SKSpriteNode(imageNamed: "Slider")
    let rightBase = SKSpriteNode(imageNamed: "Base")
    let rightSlider = SKSpriteNode(imageNamed: "Slider")
    let spot = SKSpriteNode(imageNamed: "Spot")
    let batteryLabel = SKLabelNode(text: "Charge: %")
    let temperatureLabel = SKLabelNode(text: "Temp: ℃")
    
    let roombaMaxSpeed:CGFloat = 500.0
    let goldenRatio:CGFloat = 1.618
    let baseScaleY:CGFloat = 0.90 // Proportion of screen height that the base of the sliders will take up.
    let baseScaleX:CGFloat = 0.05 // Width:Height
    let iconScale:CGFloat = 0.10
    let sliderPosition:CGFloat = 0.80
    let iconPosition:CGFloat = 0.50
    let iconSpacing:CGFloat = 1.0 // Proportion of icon spacing to icon size.
    let arrowScale:CGFloat = 0.60 // Proportion of the compass' size.
    let compassScale:CGFloat = 0.25
    
    var iconSize = CGSize?() // Related to iconScale
    var baseSize = CGSize?() // Related to sliderScale
    var sliderSize = CGSize?() // Related to sliderScale
    var compassSize = CGSize?()
    var arrowSize = CGSize?()
    
    var auto = Automation.None

    // TODO 4-16: Get all icons on screen and functioning, change joysticks to sliders
    // TODO 4-17: Formatting of layout.
    
    var rooWifi = RooWifi?()
    
    var touchTracker : [UITouch : SKNode] = [:]
    
    convenience init(size: CGSize, inout rooWifi: RooWifi) {
        self.init(size: size)
        self.rooWifi = rooWifi
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.scaleMode = .ResizeFill
        self.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.AdjustOrientation()
        self.addChild(clean)
        
        self.addChild(spot)
        self.addChild(dock)
        self.addChild(connect)
        self.addChild(motor)
        self.addChild(compass)
        self.addChild(arrow)
        self.addChild(leftBase)
        self.addChild(leftSlider)
        self.addChild(rightBase)
        self.addChild(rightSlider)
        self.addChild(batteryLabel)
        self.addChild(temperatureLabel)
        
        backgroundThread(0.0, background: {
            while (true) {
                // Constantly refresh sprites
                self.UpdateLabels()
            }
        })
    }
    
    func AdjustOrientation() {
        iconSize = CGSize(width: self.size.width * iconScale, height: self.size.width * iconScale)
        baseSize = CGSize(width: self.size.width * baseScaleX, height: self.size.height * baseScaleY)
        sliderSize = CGSize(width: baseSize!.width * goldenRatio, height: baseSize!.width)
        compassSize = CGSize(width: self.size.width * compassScale, height: self.size.width * compassScale)
        arrowSize = CGSize(width: compassSize!.width * arrowScale, height: compassSize!.width * arrowScale)
        
        clean.position = CGPointMake(self.size.width / 2 * iconPosition, self.size.width * iconScale * iconSpacing)
        clean.size = iconSize!
        
        spot.position = CGPointMake(self.size.width / 2 * iconPosition, 0.0)
        spot.size = iconSize!
        
        dock.position = CGPointMake(self.size.width / 2 * iconPosition, -self.size.width * iconScale * iconSpacing)
        dock.size = iconSize!
        
        connect.position = CGPointMake(-self.size.width / 2 * iconPosition, self.size.width * iconScale * iconSpacing)
        connect.size = iconSize!
        
        motor.position = CGPointMake(-self.size.width / 2 * iconPosition, 0.0)
        motor.size = iconSize!
        
        compass.position = self.position
        compass.size = compassSize!
        
        arrow.anchorPoint = CGPointMake(0.5, 0.5)
        arrow.position = self.position
        arrow.size = arrowSize!
        arrow.zRotation = CGFloat(M_PI_4)
        
        leftBase.position = CGPointMake(-self.size.width / 2 * sliderPosition, 0.0)
        leftBase.size = baseSize!
        leftSlider.position = leftBase.position
        leftSlider.size = sliderSize!
        
        rightBase.position = CGPointMake(self.size.width / 2 * sliderPosition, 0.0)
        rightBase.size = baseSize!
        rightSlider.position = rightBase.position
        rightSlider.size = sliderSize!
        
        batteryLabel.position = CGPointMake(-self.size.width / 2 * iconPosition, -self.size.width * iconScale * iconSpacing * 2)
        batteryLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        temperatureLabel.position = CGPointMake(self.size.width / 2 * iconPosition, -self.size.width * iconScale * iconSpacing * 2)
        temperatureLabel.fontColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func UpdateLabels() {
        batteryLabel.text = "Charge:" + String(format:"%.2f", rooWifi!.batteryLevel) + "%"
        temperatureLabel.text = "Temp: " + String(rooWifi!.sensors.Temperature) + " ℃"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(leftBase.frame, location) || CGRectContainsPoint(leftSlider.frame, location)) {
                touchTracker[touch] = leftSlider
            } else if (CGRectContainsPoint(rightBase.frame, location) || CGRectContainsPoint(rightSlider.frame, location)) {
                touchTracker[touch] = rightSlider
            } else if (CGRectContainsPoint(clean.frame, location)) {
                touchTracker[touch] = clean
            } else if (CGRectContainsPoint(spot.frame, location)) {
                touchTracker[touch] = spot
            } else if (CGRectContainsPoint(dock.frame, location)) {
                touchTracker[touch] = dock
            } else if (CGRectContainsPoint(connect.frame, location)) {
                touchTracker[touch] = connect
            } else if (CGRectContainsPoint(motor.frame, location)) {
                touchTracker[touch] = motor
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if (touchTracker[touch] == leftSlider) {
                if (abs(location.y) < leftBase.size.height/2) {
                    leftSlider.position = CGPointMake(leftBase.position.x, location.y)
                } else if location.y > 0 {
                    leftSlider.position = CGPointMake(leftBase.position.x, leftBase.size.height/2)
                } else {
                    leftSlider.position = CGPointMake(leftBase.position.x, -(leftBase.size.height)/2)
                }
            } else if (touchTracker[touch] == rightSlider) {
                if (abs(location.y) < rightBase.size.height/2) {
                    rightSlider.position = CGPointMake(rightBase.position.x, location.y)
                } else if location.y > 0 {
                    rightSlider.position = CGPointMake(rightBase.position.x, rightBase.size.height/2)
                } else {
                    rightSlider.position = CGPointMake(rightBase.position.x, -(rightBase.size.height)/2)
                }
            }
            self.Drive()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if (touchTracker[touch] == leftSlider) {
                let move:SKAction = SKAction.moveTo(leftBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                leftSlider.runAction(move)
            } else if (touchTracker[touch] == rightSlider) {
                let move:SKAction = SKAction.moveTo(rightBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                rightSlider.runAction(move)
            } else if (touchTracker[touch] == clean) {
                self.Clean()
            } else if (touchTracker[touch] == spot) {
                self.Spot()
            } else if (touchTracker[touch] == dock) {
                self.Dock()
            } else if (touchTracker[touch] == connect) {
                self.Connect()
            } else if (touchTracker[touch] == motor) {
                self.Motors()
            }
        touchTracker.removeValueForKey(touch as UITouch)
        }
        if (touchTracker.count == 0) {
            arrow.zRotation = CGFloat(M_PI_4)
        }
        self.StopDriving()
    }
    
    func Rotate(sprite: SKSpriteNode, byAngle angle: CGFloat){
        let rotate = SKAction.rotateByAngle(angle, duration: 0.1)
        sprite.runAction(rotate, withKey: "rotate")
    }
    
    func Distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist:CGFloat = p2.x - p1.x
        let yDist:CGFloat = p2.y - p1.y
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
    
    func Clean() {
        if (auto == .Clean) {
            if rooWifi!.SafeMode() {
                clean.color = ControlColors.Off
            }
            auto = .None
        }
        else {
            if rooWifi!.Clean() {
                clean.color = ControlColors.On
            }
            auto = .Clean
        }
    }
    
    func Connect() {
        rooWifi!.Start()
        rooWifi!.SafeMode()
        let start:Song =
            [(frequency: 53, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 57, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 59, duration:NOTE_DURATION_SIXTYFOURTH_NOTE)]
        
        rooWifi!.StoreSong(0, notes: start)
        if (rooWifi!.PlaySong(0)) {
            connect.color = ControlColors.On
        }
    }
    
    func Spot() {
        if (auto == .Spot) {
            rooWifi!.SafeMode()
            auto = .None
        }
        else {
            rooWifi!.Spot()
            auto = .Spot
        }
    }
    func Dock() {
        if (auto == .Dock) {
            rooWifi!.SafeMode()
            auto = .None
        }
        else {
            rooWifi!.Dock()
            auto = .Dock
        }
    }
    
    func Motors() {
        if (rooWifi!.motors == 0) {
            rooWifi!.AllCleaningMotors_On()
        }
        else {
            rooWifi!.AllCleaningMotors_Off()
        }
    }
    
    func Drive() {
        // Control the speed of the roowifi's wheels based on slider input.
        let rightDirection:CGFloat = rightSlider.position.y > rightBase.position.y ? 1.0 : -1.0
        let rightSpeed:Int = Int(Distance(rightSlider.position, p2: rightBase.position) / rightSlider.size.height / 2 * roombaMaxSpeed * rightDirection)
        
        let leftDirection:CGFloat = leftSlider.position.y > leftBase.position.y ? 1.0 : -1.0
        let leftSpeed:Int = Int(Distance(leftSlider.position, p2: leftBase.position) / leftSlider.size.height  / 2 * roombaMaxSpeed * leftDirection)

        self.rooWifi!.Drive(rightSpeed, left: leftSpeed)
        
        let backwards = (CGFloat(rightSpeed) + CGFloat(leftSpeed)) < 0
        let angle = (CGFloat(rightSpeed) - CGFloat(leftSpeed)) / roombaMaxSpeed
        arrow.zRotation = CGFloat(M_PI_4) + (angle * CGFloat(M_2_PI)) - (backwards ? CGFloat(M_PI) : 0)
        }
    
    func StopDriving() {
        self.rooWifi!.Drive(0, radius: 0)
    }
}
