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
    
    let roombaMaxSpeed:CGFloat = 500.0
    let goldenRatio:CGFloat = 1.618
    let sliderScale:CGFloat = 12.0 // Smaller for bigger sliders
    let iconScale:CGFloat = 6.0 // Size is view width / iconScale
    let sliderPosition:CGFloat = 1.4 // Position is center += viewSize / sliderPosition.
    let iconPosition:CGFloat = 2.5 // Same formula as sliderPosition. Higher is closer to center.
    let iconSpacing:CGFloat = 4 // View height / iconSpacing = spacing. Higher is closer to each other.
    let arrowScale:CGFloat = 3.0
    let compassScale:CGFloat = 2.4 // Size is view width / compassScale
    let baseMargins:CGFloat = 10.0 // Distance from slider to edges of screen
    
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
        self.backgroundColor.colorWithAlphaComponent(0.0)
        iconSize = CGSize(width: self.size.width / iconScale, height: self.size.height/iconScale)
        baseSize = CGSize(width: self.size.width / sliderScale, height: self.size.height - (baseMargins * 2))
        sliderSize = CGSize(width: self.size.height / sliderScale * goldenRatio * goldenRatio, height: self.size.height / sliderScale * goldenRatio)
        compassSize = CGSize(width: self.size.width / compassScale, height: self.size.width / compassScale)
        arrowSize = CGSize(width: compassSize!.width - (compassSize!.width / arrowScale), height: compassSize!.height - (compassSize!.height / arrowScale))
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.scaleMode = .ResizeFill
        self.backgroundColor = UIColor(red: 120, green: 120, blue: 120, alpha: 1.0)
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(clean)
        clean.position = CGPointMake(self.size.width/iconPosition, self.size.height/iconSpacing)
        clean.size = iconSize!
        
        self.addChild(spot)
        spot.position = CGPointMake(self.size.width/iconPosition, 0.0)
        spot.size = iconSize!
        
        self.addChild(dock)
        dock.position = CGPointMake(self.size.width/iconPosition, -(self.size.height/iconSpacing))
        dock.size = iconSize!
        
        self.addChild(connect)
        connect.position = CGPointMake(-(self.size.width/iconPosition), self.size.height/iconSpacing)
        connect.size = iconSize!
        
        self.addChild(motor)
        motor.position = CGPointMake(-(self.size.width/iconPosition), 0.0)
        motor.size = iconSize!
        
        self.addChild(compass)
        compass.position = self.position
        compass.size = compassSize!
        
        self.addChild(arrow)
        arrow.anchorPoint = CGPointMake(0.5, 0.5)
        arrow.position = self.position
        arrow.size = arrowSize!
        arrow.zRotation = CGFloat(M_PI_4)
        
        self.addChild(leftBase)
        leftBase.position = CGPointMake(-(self.size.width/sliderPosition), 0.0)
        leftBase.size = baseSize!

        self.addChild(leftSlider)
        leftSlider.position = leftBase.position
        leftSlider.size = sliderSize!
        
        self.addChild(rightBase)
        rightBase.position = CGPointMake(self.size.width/sliderPosition, 0.0)
        rightBase.size = baseSize!
        
        self.addChild(rightSlider)
        rightSlider.position = rightBase.position
        rightSlider.size = sliderSize!
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
