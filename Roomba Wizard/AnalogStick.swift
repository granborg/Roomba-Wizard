//
//  AnalogStick.swift
//  Roomba Wizard
//
//  Created by Brett Granborg on 4/10/16.
//  Copyright © 2016 Brett Granborg. All rights reserved.
//

import SpriteKit

class AnalogStick: SKScene {

    let base = SKSpriteNode(imageNamed: "Base")
    let ball = SKSpriteNode(imageNamed: "Ball")
    var rooWifi = RooWifi?()
    
    var stickActive = false
    
    convenience init(size: CGSize, inout rooWifi: RooWifi) {
        self.init(size: size)
        self.rooWifi = rooWifi
    }
    
    override func didMoveToView(view: UIView) {
        /* Setup your scene here */
        self.anchorPoint = CGPointMake(0.5, 0.5)
        
        self.addChild(base)
        self.position = base.position
        
        self.addChild(ball)
        ball.position = base.position
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
    
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(base.frame, location)) {
                self.stickActive = true
            } else {
                self.stickActive = false
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            let v = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
            let angle = atan2(v.dy, v.dx)
            
            let length:CGFloat = base.frame.size.height / 2
            
            let xDist:CGFloat = sin(angle - 1.57079633) * length
            let yDist:CGFloat = cos(angle - 1.57079633) * length
            
            if (CGRectContainsPoint(base.frame, location)) {
                ball.position = location
            } else {
                ball.position = CGPointMake(base.position.x - xDist, base.position.y + yDist)
            }
            self.Drive(angle)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.stickActive) {
            let move:SKAction = SKAction.moveTo(base.position, duration: 0.2)
            move.timingMode = .EaseOut
            ball.runAction(move)
        }
        self.StopDriving()
    }
    
    func Drive(angle:CGFloat) {
        // Control the speed of the roowifi's wheels based on the angle.
        // direction: Up = 3, Right = 2, Down = 1, Left = 0
        let direction = ((angle * CGFloat(180 / M_PI) / 90) + 2.5) % 4
        print(direction)
        let speed = 500
        if (1 < direction && direction < 2) {
            // Analog stick pointed backward
            self.rooWifi!.Drive(speed * -1, left: speed * -1)
        } else if (2 < direction && direction < 3) {
            // Analog stick pointed right
            if (direction > (floor(direction) + 0.5)) {
                // Right up
                self.rooWifi!.Drive(
                    speed * Int(abs(direction - floor(direction))),
                    left: speed)
            }
            else {
                // Right down
                self.rooWifi!.Drive(
                    speed * -1,
                    left:speed * Int(abs(1 - direction - floor(direction))))
            }
        } else if (direction < 1) {
            // Analog stick pointed left
            if (direction > (floor(direction) + 0.5)) {
                // Left down
                self.rooWifi!.Drive(
                   speed * Int(abs(1 - direction - floor(direction))),
                   left: speed * -1)
            }
            else {
                // Left up
                self.rooWifi!.Drive(
                    speed,
                    left: speed * Int(abs(direction - floor(direction))))
            }
        } else {
            self.rooWifi!.Drive(500, left: 500)
        }
    }
    
    func StopDriving() {
        self.rooWifi!.Drive(0, radius: 0)
    }
}
