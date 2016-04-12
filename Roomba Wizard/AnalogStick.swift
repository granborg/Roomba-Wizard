//
//  AnalogStick.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/10/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import SpriteKit

class AnalogStick: SKScene {

    let leftBase = SKSpriteNode(imageNamed: "Base")
    let leftBall = SKSpriteNode(imageNamed: "Ball")
    
    let rightBase = SKSpriteNode(imageNamed: "Base")
    let rightBall = SKSpriteNode(imageNamed: "Ball")
    
    var rooWifi = RooWifi?()
    var rightAngle:CGFloat = 0
    var leftAngle:CGFloat = 0
    
    var touchTracker : [UITouch : SKNode] = [:]
    
    convenience init(size: CGSize, inout rooWifi: RooWifi) {
        self.init(size: size)
        self.rooWifi = rooWifi
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(leftBase)
        leftBase.position = CGPointMake(-120, 50)
        
        self.addChild(leftBall)
        leftBall.position = leftBase.position
        
        self.addChild(rightBase)
        rightBase.position = CGPointMake(120, 50)
        
        self.addChild(rightBall)
        rightBall.position = rightBase.position
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(leftBase.frame, location)) {
                touchTracker[touch] = leftBall
            }
            else if (CGRectContainsPoint(rightBase.frame, location)) {
                touchTracker[touch] = rightBall
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if (touchTracker[touch] == leftBall) {
                let v = CGVector(dx: location.x - leftBase.position.x, dy: location.y - leftBase.position.y)
                self.leftAngle = atan2(v.dy, v.dx)
            
                let length:CGFloat = leftBase.frame.size.height / 2
            
                let xDist:CGFloat = sin(self.leftAngle - 1.57079633) * length
                let yDist:CGFloat = cos(self.leftAngle - 1.57079633) * length
            
                if (CGRectContainsPoint(leftBase.frame, location)) {
                    leftBall.position = location
                } else {
                    leftBall.position = CGPointMake(leftBase.position.x - xDist, leftBase.position.y + yDist)
                }
            }
            else if (touchTracker[touch] == rightBall) {
                let v = CGVector(dx: location.x - rightBase.position.x, dy: location.y - rightBase.position.y)
                self.rightAngle = atan2(v.dy, v.dx)
                
                let length:CGFloat = rightBase.frame.size.height / 2
                
                let xDist:CGFloat = sin(self.rightAngle - 1.57079633) * length
                let yDist:CGFloat = cos(self.rightAngle - 1.57079633) * length
                
                if (CGRectContainsPoint(rightBase.frame, location)) {
                    rightBall.position = location
                } else {
                    rightBall.position = CGPointMake(rightBase.position.x - xDist, rightBase.position.y + yDist)
                }

            }
            self.Drive()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            if (touchTracker[touch] == leftBall) {
                let move:SKAction = SKAction.moveTo(leftBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                leftBall.runAction(move)
            }
            else if (touchTracker[touch] == rightBall) {
                let move:SKAction = SKAction.moveTo(rightBase.position, duration: 0.2)
                move.timingMode = .EaseOut
                rightBall.runAction(move)
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
    
    func Drive() {
        // Control the speed of the roowifi's wheels based on Analog stick input.
        let rightDirection:CGFloat = (((self.rightAngle * CGFloat(180 / M_PI)) + 2.5) % 4 / 4) > 0 ? 1 : -1
        let rightSpeed = Int(Distance(rightBall.position, p2: rightBase.position) / 100 * 500 * rightDirection)
        
        let leftDirection:CGFloat = (((self.leftAngle * CGFloat(180 / M_PI)) + 2.5) % 4 / 4) > 0 ? 1 : -1
        let leftSpeed:Int = Int(Distance(leftBall.position, p2: leftBase.position) / 100 * 500 * leftDirection)

        self.rooWifi!.Drive(rightSpeed, left: leftSpeed)
        }
    
    func StopDriving() {
        self.rooWifi!.Drive(0, radius: 0)
    }
}
