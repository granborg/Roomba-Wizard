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
        let Off = UIColor.blackColor()
        let On = UIColor.greenColor()
    }
    let ControlColors = Colors()
    
    let arrow = SKSpriteNode(imageNamed: "Arrow")
    let clean = SKSpriteNode(imageNamed: "Clean")
    let compass = SKSpriteNode(imageNamed: "Compass")
    let connect = SKSpriteNode(imageNamed: "Connect")
    let dock = SKSpriteNode(imageNamed: "Dock_Transparent")
    let spot = SKSpriteNode(imageNamed: "Spot")
    let leftBase = SKSpriteNode(imageNamed: "Base")
    let leftSlider = SKSpriteNode(imageNamed: "Slider")
    let rightBase = SKSpriteNode(imageNamed: "Base")
    let rightSlider = SKSpriteNode(imageNamed: "Slider")
    
    var sideBrushKnob = SKSpriteNode(imageNamed: "Knob")
    var vacuumKnob = SKSpriteNode(imageNamed: "Knob")
    var mainBrushKnob = SKSpriteNode(imageNamed: "Knob")

    let batteryLabel = SKLabelNode(text: "Charge: %")
    let temperatureLabel = SKLabelNode(text: "Temp: ℃")
    let sideBrushLabel = SKLabelNode(text: "Side Brush")
    let vacuumLabel = SKLabelNode(text: "Vacuum")
    let mainBrushLabel = SKLabelNode(text: "Main Brushes")
    
    let roombaMaxSpeed:CGFloat = 500.0
    let goldenRatio:CGFloat = 1.618
    let baseScaleY:CGFloat = 0.85// Proportion of screen height that the base of the sliders will take up.
    let baseScaleX:CGFloat = 0.05 // Width:Height
    let basePositionY:CGFloat = 0.0
    let iconScale:CGFloat = 0.10
    let knobScale:CGFloat = 0.18
    let basePositionX:CGFloat = 0.90
    let iconPosition:CGFloat = 0.50
    let labelPosition:CGFloat = 0.40
    let iconSpacing:CGFloat = 1.0 // Proportion of icon spacing to icon size.
    let arrowScale:CGFloat = 0.60 // Proportion of the compass' size.
    let compassScale:CGFloat = 0.20
    
    var iconSize = CGSize?() // Related to iconScale
    var fontSize = CGFloat?() // Related to iconSize
    var knobSize = CGSize?()
    var baseSize = CGSize?() // Related to baseScale
    var sliderSize = CGSize?() // Related to baseScale
    var compassSize = CGSize?()
    var arrowSize = CGSize?()
    
    var auto = Automation.None
    var drive = 0 // Modulo this to keep from sending too many drive commands.
    
    var rooWifi = RooWifi?()
    
    var touchTracker : [UITouch : SKNode] = [:]
    
    convenience init(size: CGSize, inout rooWifi: RooWifi) {
        self.init(size: size)
        self.rooWifi = rooWifi
    }
    
    func ChangeColor(image: SKSpriteNode, color: UIColor) {
        let colorize = SKAction.colorizeWithColor(color, colorBlendFactor: 0.8, duration: 0.05)
        image.runAction(colorize)
    }
    
    func UpdateKnob(inout knob: SKSpriteNode, toLocation location: CGPoint) -> (Bool, Double){
        var valid:Bool = false
        var degrees:Float = 0.0
        let deltaX:CGFloat = location.x - knob.position.x;
        let deltaY:CGFloat = location.y - knob.position.y;
        let angle:Double = atan2(Double(deltaY), Double(deltaX))
        if (angle < -(M_PI_2 + M_PI_4)) == (angle < -M_PI_4) {
            // Knob-like radian constraints.
            valid = true
            knob.zRotation = CGFloat(angle - M_PI_4)
            degrees = GLKMathRadiansToDegrees(Float(angle)) + 180
            if degrees < 45 {
                degrees = 45 - degrees
            } else if degrees > 135 {
                degrees = 360 - degrees
            }
        }
        return (valid, Double(degrees) / Double(225))
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.scaleMode = .ResizeFill
        self.backgroundColor = UIColor.whiteColor()
        self.anchorPoint = CGPointMake(0.5, 0.5)
        self.AdjustOrientation()
        self.addChild(clean)
        self.addChild(spot)
        self.addChild(dock)
        self.addChild(connect)
        self.addChild(compass)
        self.addChild(arrow)
        self.addChild(leftBase)
        self.addChild(leftSlider)
        self.addChild(rightBase)
        self.addChild(rightSlider)
        self.addChild(sideBrushKnob)
        self.addChild(vacuumKnob)
        self.addChild(mainBrushKnob)
        self.addChild(batteryLabel)
        self.addChild(temperatureLabel)
        self.addChild(sideBrushLabel)
        self.addChild(vacuumLabel)
        self.addChild(mainBrushLabel)
        
        backgroundThread(0.0, background: {
            while (true) {
                // Constantly refresh sprites
                self.UpdateNodes()
                sleep(1)
            }
        })
    }
    
    func AdjustOrientation() {
        iconSize = CGSize(width: self.size.width * iconScale, height: self.size.width * iconScale)
        knobSize = CGSize(width: self.size.width * knobScale, height: self.size.width * knobScale)
        baseSize = CGSize(width: self.size.width * baseScaleX, height: self.size.height * baseScaleY)
        sliderSize = CGSize(width: baseSize!.width * goldenRatio, height: baseSize!.width)
        compassSize = CGSize(width: self.size.width * compassScale, height: self.size.width * compassScale)
        arrowSize = CGSize(width: compassSize!.width * arrowScale, height: compassSize!.width * arrowScale)
        fontSize = iconSize!.height / 3
        
        clean.position = CGPointMake(self.size.width / 2 * iconPosition, self.size.width * iconScale * iconSpacing * 2)
        clean.size = iconSize!
        self.ChangeColor(clean, color: ControlColors.Off)
        
        spot.position = CGPointMake(self.size.width / 2 * iconPosition , self.size.width * iconScale * iconSpacing)
        spot.size = iconSize!
        self.ChangeColor(spot, color: ControlColors.Off)
        
        dock.position = CGPointMake(-self.size.width / 2 * iconPosition, self.size.width * iconScale * iconSpacing)
        dock.size = iconSize!
        self.ChangeColor(dock, color: ControlColors.Off)
        
        connect.position = CGPointMake(-self.size.width / 2 * iconPosition, self.size.width * iconScale * iconSpacing * 2)
        connect.size = iconSize!
        self.ChangeColor(connect, color: ControlColors.Off)
        
        compass.position = CGPointMake(0.0, self.size.width * iconScale * iconSpacing * 2)
        compass.size = compassSize!
        arrow.anchorPoint = CGPointMake(0.5, 0.5)
        arrow.position = compass.position
        arrow.size = arrowSize!
        arrow.zRotation = CGFloat(M_PI_4)
        
        leftBase.position = CGPointMake(-self.size.width / 2 * basePositionX, self.size.height / 2 * basePositionY)
        leftBase.size = baseSize!
        leftSlider.position = leftBase.position
        leftSlider.size = sliderSize!
        
        rightBase.position = CGPointMake(self.size.width / 2 * basePositionX, self.size.height / 2 * basePositionY)
        rightBase.size = baseSize!
        rightSlider.position = rightBase.position
        rightSlider.size = sliderSize!
        
        sideBrushKnob.position = CGPointMake(-self.size.width / 2 * iconPosition, -self.size.height * knobScale * iconSpacing)
        sideBrushKnob.size = knobSize!
        sideBrushKnob.zRotation = CGFloat(M_PI)
        
        vacuumKnob.position = CGPointMake(0.0, -self.size.height * knobScale * iconSpacing)
        vacuumKnob.size = knobSize!
        vacuumKnob.zRotation = CGFloat(M_PI)
        
        mainBrushKnob.position = CGPointMake(self.size.width / 2 * iconPosition, -self.size.height * knobScale * iconSpacing)
        mainBrushKnob.size = knobSize!
        mainBrushKnob.zRotation = CGFloat(M_PI)
        
        batteryLabel.position = CGPointMake(-self.size.width / 2 * labelPosition, 0.0)
        batteryLabel.fontColor = UIColor.blackColor()
        batteryLabel.fontSize = fontSize!
        
        temperatureLabel.position = CGPointMake(self.size.width / 2 * labelPosition, 0.0)
        temperatureLabel.fontColor = UIColor.blackColor()
        temperatureLabel.fontSize = fontSize!
        
        sideBrushLabel.position = CGPointMake(sideBrushKnob.position.x, sideBrushKnob.position.y - knobSize!.height / goldenRatio)
        sideBrushLabel.fontColor = UIColor.blackColor()
        sideBrushLabel.fontSize = fontSize!
        
        vacuumLabel.position = CGPointMake(vacuumKnob.position.x, vacuumKnob.position.y - knobSize!.height / goldenRatio)
        vacuumLabel.fontColor = UIColor.blackColor()
        vacuumLabel.fontSize = fontSize!
        
        mainBrushLabel.position = CGPointMake(mainBrushKnob.position.x, mainBrushKnob.position.y - knobSize!.height / goldenRatio)
        mainBrushLabel.fontColor = UIColor.blackColor()
        mainBrushLabel.fontSize = fontSize!
    }
    
    func UpdateNodes() {
        batteryLabel.text = "Charge:" + String(format:"%.2f", rooWifi!.batteryLevel * 100) + "%"
        temperatureLabel.text = "Temp: " + String(rooWifi!.sensors.Temperature) + " ℃"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(leftBase.frame, location) || CGRectContainsPoint(leftSlider.frame, location)) {
                touchTracker[touch] = leftSlider
                self.ChangeColor(leftSlider, color: UIColor.redColor())
            } else if (CGRectContainsPoint(rightBase.frame, location) || CGRectContainsPoint(rightSlider.frame, location)) {
                touchTracker[touch] = rightSlider
                self.ChangeColor(rightSlider, color: UIColor.redColor())
            } else if (CGRectContainsPoint(clean.frame, location)) {
                touchTracker[touch] = clean
            } else if (CGRectContainsPoint(spot.frame, location)) {
                touchTracker[touch] = spot
            } else if (CGRectContainsPoint(dock.frame, location)) {
                touchTracker[touch] = dock
            } else if (CGRectContainsPoint(connect.frame, location)) {
                touchTracker[touch] = connect
            } else if (CGRectContainsPoint(sideBrushKnob.frame, location)) {
                touchTracker[touch] = sideBrushKnob
            } else if (CGRectContainsPoint(vacuumKnob.frame, location)) {
                touchTracker[touch] = vacuumKnob
            } else if (CGRectContainsPoint(mainBrushKnob.frame, location)) {
                touchTracker[touch] = mainBrushKnob
            }
        }
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if (touchTracker[touch] == leftSlider) {
                if abs(location.y) < leftBase.size.height / 2 + leftBase.position.y {
                    leftSlider.position = CGPointMake(leftBase.position.x, location.y)
                } else if location.y > 0 {
                    leftSlider.position = CGPointMake(leftBase.position.x, leftBase.size.height / 2 + leftBase.position.y)
                } else {
                    leftSlider.position = CGPointMake(leftBase.position.x, -(leftBase.size.height / 2) + leftBase.position.y)
                }
                self.Drive()
                break
            } else if (touchTracker[touch] == rightSlider) {
                if abs(location.y) < rightBase.size.height / 2 + rightBase.position.y {
                    rightSlider.position = CGPointMake(rightBase.position.x, location.y)
                } else if location.y > 0 {
                    rightSlider.position = CGPointMake(rightBase.position.x, rightBase.size.height / 2 + rightBase.position.y)
                } else {
                    rightSlider.position = CGPointMake(rightBase.position.x, -(rightBase.size.height / 2) + rightBase.position.y)
                }

                self.Drive()
                break
            } else if (touchTracker[touch] == sideBrushKnob) {
                let (valid, percent) = UpdateKnob(&sideBrushKnob, toLocation: location)
                if valid {
                    rooWifi!.sideBrushPercent(percent)
                }
            } else if (touchTracker[touch] == mainBrushKnob) {
                let (valid, percent) = UpdateKnob(&mainBrushKnob, toLocation: location)
                if valid {
                    rooWifi!.mainBrushPercent(percent)
                }
            } else if (touchTracker[touch] == vacuumKnob) {
                let (valid, percent) = UpdateKnob(&vacuumKnob, toLocation: location)
                if valid {
                    rooWifi!.vacuumPercent(percent)
                }
            }
            rooWifi?.UpdateMotorsPrecise()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if (touchTracker[touch] == leftSlider) {
                let move:SKAction = SKAction.moveTo(leftBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                leftSlider.runAction(move)
                self.ChangeColor(leftSlider, color: UIColor.whiteColor())
                self.StopDriving()
            } else if (touchTracker[touch] == rightSlider) {
                let move:SKAction = SKAction.moveTo(rightBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                rightSlider.runAction(move)
                self.ChangeColor(rightSlider, color: UIColor.whiteColor())
                self.StopDriving()
            } else if (touchTracker[touch] == clean) {
                self.Clean()
            } else if (touchTracker[touch] == spot) {
                self.Spot()
            } else if (touchTracker[touch] == dock) {
                self.Dock()
            } else if (touchTracker[touch] == connect) {
                UIView.animateWithDuration(0.5) {
                    self.connect.alpha = 1
                }
                self.Connect()
            }
        touchTracker.removeValueForKey(touch as UITouch)
        }
        if (touchTracker.count == 0) {
            arrow.zRotation = CGFloat(M_PI_4)
        }
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
                //self.ChangeColor(clean, color: ControlColors.Off)
            }
            auto = .None
        } else if rooWifi!.Clean() {
            //self.ChangeColor(clean, color: ControlColors.On)
            auto = .Clean
        }
    }
    
    func Connect() {
        rooWifi!.Start()
        let start:Song =
            [(frequency: 53, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 57, duration:NOTE_DURATION_SIXTYFOURTH_NOTE),
             (frequency: 59, duration:NOTE_DURATION_SIXTYFOURTH_NOTE)]
        
        rooWifi!.StoreSong(0, notes: start)
        if (rooWifi!.PlaySong(0)) {
            //self.ChangeColor(connect, color: ControlColors.On)
        }
    }
    
    func Spot() {
        if (auto == .Spot) {
            if rooWifi!.SafeMode() {
                //self.ChangeColor(spot, color: ControlColors.Off)
            }
            auto = .None
        } else if rooWifi!.Spot() {
            self.ChangeColor(spot, color: ControlColors.On)
            auto = .Spot
        }
    }
    
    func Dock() {
        if (auto == .Dock) {
            //self.ChangeColor(dock, color: UIColor.whiteColor())
            if rooWifi!.SafeMode() {
                dock.color = ControlColors.Off
            }
            auto = .None
        } else if rooWifi!.Dock() {
            self.ChangeColor(dock, color: UIColor.greenColor())
            dock.color = ControlColors.On
            auto = .Dock
        }
    }
    
    func Motors() {
    }
    
    func Drive() {
        // Control the speed of the roowifi's wheels based on slider input.
        let rightDirection:CGFloat = rightSlider.position.y > rightBase.position.y ? 1.0 : -1.0
        let rightSpeed:Int = Int(Distance(rightSlider.position, p2: rightBase.position) / rightSlider.size.height / 2 * roombaMaxSpeed * rightDirection)
        
        let leftDirection:CGFloat = leftSlider.position.y > leftBase.position.y ? 1.0 : -1.0
        let leftSpeed:Int = Int(Distance(leftSlider.position, p2: leftBase.position) / leftSlider.size.height  / 2 * roombaMaxSpeed * leftDirection)
        
        self.drive += 1
        //if (drive % 6 == 0) {
            self.rooWifi!.Drive(rightSpeed, left: leftSpeed)
        //}
        
        let backwards = (CGFloat(rightSpeed) + CGFloat(leftSpeed)) < 0
        let angle = (CGFloat(rightSpeed) - CGFloat(leftSpeed)) / roombaMaxSpeed
        arrow.zRotation = CGFloat(M_PI_4) + (angle * CGFloat(M_2_PI)) - (backwards ? CGFloat(M_PI) : 0)
        }
    
    func StopDriving() {
        self.rooWifi!.Drive(0, radius: 0)
    }
}
