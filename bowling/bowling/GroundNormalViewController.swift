//
//  GroundNormalViewController.swift
//  bowling
//
//  Created by Max on 19/10/2019.
//  Copyright © 2019 Max. All rights reserved.
//

import UIKit
var isLoopAlive = true
var isGameAlive = true
class GroundNormalViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    @IBOutlet weak var debugLabel: UILabel!
}

class PlayArea : UIView {
    
    
    var alreadyPlayed = false
    var pointsArray = [CGPoint]()
    var speedX: Float = 0
    var speedY: Float = 0
    var startPoint: CGPoint = CGPoint()
    var endPoint: CGPoint = CGPoint()
    var countPoint: Int = 0
    
    
    class PhysicObject {
        var size: Float = 25
        var localSpeedX: Float = 0
        var localSpeedY: Float = 0
        var positionX: Float
        var positionY: Float
        var friction: Float = 1
        var isAlive: Bool = true
        
        func refreshSpeed(){
            
        }
        
        func refreshPosition(){
            localSpeedX = localSpeedX * friction
            localSpeedY = localSpeedY * friction
            positionY += localSpeedY
            positionX += localSpeedX
        }
        
        func getPosition() -> CGPoint {
            return CGPoint(x: CGFloat(positionX), y: CGFloat(positionY))
        }
        
        func setSpeed(speedToX: Float, speedToY: Float){
            localSpeedX = speedToX
            localSpeedY = speedToY
        }
        
        func setPos(posToX: Float, posToY: Float){
            positionX = posToX
            positionY = posToY
        }
        
        func checkWallTouch(){
            if (positionX + size) > Float(UIScreen.main.bounds.maxX){
                NSLog("Touched right side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }
            if (positionX - size) < Float(UIScreen.main.bounds.maxX){
                NSLog("Touched left side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }
            if (positionY + size) > Float(UIScreen.main.bounds.maxY){
                NSLog("Touched down side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }
            /*if (positionY - size) < Float(UIScreen.main.bounds.maxY){
                NSLog("Touched up side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }*/
        }
        
        init(tmpPositionX: Float, tmpPositionY: Float){
            positionX = tmpPositionX
            positionY = tmpPositionY
        }
    }
    
    let playerCircle = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.5, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.75)
    let skittles1 = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.33, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.15)
    let skittles2 = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.66, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.15)
    
    override func draw(_ rect: CGRect) {
        UIColor.blue.set()
        
        let background = UIBezierPath(rect: rect)
        background.fill()
        
            var path = UIBezierPath(arcCenter: playerCircle.getPosition(), radius: CGFloat(playerCircle.size), startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true)
            UIColor.orange.set()
            path.fill()
        
        if skittles1.isAlive {
            var path = UIBezierPath(arcCenter: skittles1.getPosition(), radius: CGFloat(skittles1.size), startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true)
            UIColor.green.set()
            path.fill()
        }
        
        if skittles2.isAlive {
            var path = UIBezierPath(arcCenter: skittles2.getPosition(), radius: CGFloat(skittles2.size), startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true)
            UIColor.green.set()
            path.fill()
        }
                  
        
        
        
        
    }
    
    func loop(){
        let loopTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            self.playerCircle.refreshPosition()
            
            NSLog(String(self.playerCircle.positionY))
            self.setNeedsDisplay()
            
            self.playerCircle.checkWallTouch()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if alreadyPlayed == false {
            countPoint += 1
            var tmpPoint = touches.first!.location(in: self)
            pointsArray.append(tmpPoint)
            
            if pointsArray.count > 3 {
                var tmpPoint = touches.first!
                startPoint = pointsArray.first!
                endPoint = pointsArray.last!
                NSLog("Assez de points pour faire un trajet")
                var endPointX = Float(endPoint.x)
                var endPointY = Float(endPoint.y)
                var startPointX = Float(startPoint.x)
                var startPointY = Float(startPoint.y)
                speedX =  (endPointX - startPointX)/4
                speedY =  (endPointY - startPointY)/4
                NSLog(String(speedX))
                NSLog(String(speedY))
                playerCircle.setSpeed(speedToX: speedX, speedToY: speedY)
                loop()
                alreadyPlayed = true
                
            } else {
                NSLog("Pas assez de points pour faire un trajet")
            }
        }
        
    }

}
