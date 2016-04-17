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

    let clean = SKSpriteNode(imageNamed: "Clean")
    let connect = SKSpriteNode(imageNamed: "Connect")
    let dock = SKSpriteNode(imageNamed: "Dock")
    let motor = SKSpriteNode(imageNamed: "Motor")
    let leftBase = SKSpriteNode(imageNamed: "Base")
    let leftSlider = SKSpriteNode(imageNamed: "Slider")
    let rightBase = SKSpriteNode(imageNamed: "Base")
    let rightSlider = SKSpriteNode(imageNamed: "Slider")
    let spot = SKSpriteNode(imageNamed: "Spot")
    
    let goldenRatio:CGFloat = 1.618
    let sliderScale:CGFloat = 5.0
    let iconScale:CGFloat = 5.0
    
    var iconSize = CGSize?() // Related to iconScale
    var baseSize = CGSize?() // Related to sliderScale
    var sliderSize = CGSize?() // Related to sliderScale
    
    var velocity = 0
    var radius = 0

    var auto = Automation.None

    // TODO 4-16: Get all icons on screen and functioning, change joysticks to sliders
    // TODO 4-17: Formatting of layout.
    
    var rooWifi = RooWifi?()
    var rightAngle:CGFloat = 0
    var leftAngle:CGFloat = 0
    
    var touchTracker : [UITouch : SKNode] = [:]
    
    convenience init(size: CGSize, inout rooWifi: RooWifi) {
        self.init(size: size)
        self.rooWifi = rooWifi
        self.backgroundColor.colorWithAlphaComponent(0.0)
        iconSize = CGSize(width: self.size.height/iconScale, height: self.size.width/iconScale)
        baseSize = CGSize(width: self.size.height/sliderScale, height: self.size.width/sliderScale)
        sliderSize = CGSize(width: self.size.height/sliderScale * goldenRatio, height: self.size.width/sliderScale)
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.scaleMode = .ResizeFill
        self.backgroundColor = UIColor(red: 120, green: 120, blue: 120, alpha: 1.0)
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(clean)
        clean.position = CGPointMake(self.size.width/4, self.size.height/4)
        clean.size = iconSize!
        
        self.addChild(connect)
        connect.position = CGPointMake(self.size.width/4, 0.0)
        connect.size = iconSize!
        
        self.addChild(leftBase)
        leftBase.position = CGPointMake(-(self.size.width/2), 0.0)
        leftBase.size = baseSize!

        self.addChild(leftSlider)
        leftSlider.position = leftBase.position
        leftSlider.size = sliderSize!
        
        self.addChild(rightBase)
        rightBase.position = CGPointMake(self.size.width/2, 0.0)
        rightBase.size = baseSize!
        
        self.addChild(rightSlider)
        rightSlider.position = rightBase.position
        rightSlider.size = sliderSize!
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(leftBase.frame, location)) {
                touchTracker[touch] = leftSlider
            }
            else if (CGRectContainsPoint(rightBase.frame, location)) {
                touchTracker[touch] = rightSlider
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if (touchTracker[touch] == leftSlider) {
                let v = CGVector(dx: location.x - leftBase.position.x, dy: location.y - leftBase.position.y)
                self.leftAngle = atan2(v.dy, v.dx)
            
                let length:CGFloat = leftBase.frame.size.height / 2
                
                let yDist:CGFloat = cos(self.leftAngle - 1.57079633) * length
                leftSlider.position = CGPointMake(leftBase.position.x, leftBase.position.y + yDist)

            }
            else if (touchTracker[touch] == rightSlider) {
                let v = CGVector(dx: location.x - rightBase.position.x, dy: location.y - rightBase.position.y)
                self.rightAngle = atan2(v.dy, v.dx)
                
                let length:CGFloat = rightBase.frame.size.height / 2
                
                let yDist:CGFloat = cos(self.rightAngle - 1.57079633) * length
                rightSlider.position = CGPointMake(rightBase.position.x, rightBase.position.y + yDist)
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
            }
            else if (touchTracker[touch] == rightSlider) {
                let move:SKAction = SKAction.moveTo(rightBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                rightSlider.runAction(move)
            }
        touchTracker.removeValueForKey(touch as UITouch)
        }
        self.StopDriving()
    }
    
    func Distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        let xDist:CGFloat = p2.x - p1.x
        let yDist:CGFloat = p2.y - p1.y
        return sqrt((xDist * xDist) + (yDist * yDist));
    }
    
    func Clean() {
        if (auto == .Clean) {
            rooWifi!.SafeMode()
            auto = .None
        }
        else {
            rooWifi!.Clean()
            auto = .Clean
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
    
    func Connect() {
        rooWifi!.Start()
        rooWifi!.SafeMode()
        let start:Song =
            [(frequency: 53, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 57, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 59, duration:NOTE_DURATION_SIXTYFOURTH_NOTE)]
        
        rooWifi!.StoreSong(0, notes: start)
        rooWifi!.PlaySong(0)
    }
    
    func Drive() {
        // Control the speed of the roowifi's wheels based on Analog stick input.
        let rightDirection:CGFloat = (((self.rightAngle * CGFloat(180 / M_PI)) + 2.5) % 4 / 4) > 0 ? 1 : -1
        let rightSpeed = Int(Distance(rightSlider.position, p2: rightBase.position) / 100 * 500 * rightDirection)
        
        let leftDirection:CGFloat = (((self.leftAngle * CGFloat(180 / M_PI)) + 2.5) % 4 / 4) > 0 ? 1 : -1
        let leftSpeed:Int = Int(Distance(leftSlider.position, p2: leftBase.position) / 100 * 500 * leftDirection)

        self.rooWifi!.Drive(rightSpeed, left: leftSpeed)
        }
    
    func StopDriving() {
        self.rooWifi!.Drive(0, radius: 0)
    }
}
