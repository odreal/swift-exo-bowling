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
    
    
    class PhysicObject {
        var size: Float = 25
        var localSpeedX: Float = 0
        var localSpeedY: Float = 0
        var positionX: Float
        var positionY: Float
        var friction: Float = 1
        var isAlive: Bool = true
        var localSpeedVector: Float = 0
        var weight: Float = 1
        
        func refreshPosition(){
            localSpeedX = localSpeedX * friction
            localSpeedY = localSpeedY * friction
            positionY += localSpeedY
            positionX += localSpeedX
            localSpeedVector = sqrt( localSpeedX*localSpeedX + localSpeedY*localSpeedY)
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
        
        func getPos()-> CGPoint{
            return CGPoint(x: CGFloat(positionX), y: CGFloat(positionY))
        }
        
        func checkWallTouch(){
            if (positionX + size) > Float(UIScreen.main.bounds.maxX){
                NSLog("Touched right side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }
            if (positionX - size) < Float(UIScreen.main.bounds.minX){
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
            if (positionY - size) < Float(UIScreen.main.bounds.minY){
                NSLog("Touched up side of the screen")
                localSpeedX = 0
                localSpeedY = 0
                isAlive = false
            }
        }
        
        init(tmpPositionX: Float, tmpPositionY: Float){
            positionX = tmpPositionX
            positionY = tmpPositionY
        }
    }
        
    let playerCircle = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.5, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.75)
    let skittles1 = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.33, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.15)
    let skittles2 = PhysicObject(tmpPositionX : Float(UIScreen.main.bounds.maxX)*0.66, tmpPositionY : Float(UIScreen.main.bounds.maxY)*0.15)
    
    func collisionChecker(element1 : PhysicObject, element2 : PhysicObject){
        let maxRange = (element1.size+element2.size)*(element1.size+element2.size)
        let estimatedRange = (element2.positionX-element1.positionX)*(element2.positionX-element1.positionX) + (element1.positionY-element2.positionY)*(element1.positionY-element2.positionY)
        if estimatedRange <= maxRange {
            NSLog("CONTACTCONTACT")
            //On determine un point de l'axe de notre premier élement
            let el1PrePosY = element1.positionY - element1.localSpeedY
            let el1PrePosX = element1.positionX - element1.localSpeedX
            NSLog("Equation droite passant pas les deux cercles")
            NSLog("EQ1 POINT A : X")
            NSLog(String(element1.positionX))
            NSLog("EQ1 POINT B : X")
            NSLog(String(element2.positionX))
            NSLog("EQ1 POINT A : Y")
            NSLog(String(element1.positionY))
            NSLog("EQ1 POINT B : Y")
            NSLog(String(element2.positionY))
            NSLog("EQ2 POINT A : X")
            NSLog(String(el1PrePosX))
            NSLog("EQ2 POINT A : Y")
            NSLog(String(el1PrePosY))
            
            
            //On détermine a et b de l'eqt de la droite ax+b pour la droite passant par les deux centes des cercles
            let eqtAChoc = (element2.positionY - element1.positionY) / (element2.positionX - element1.positionX)
            let eqtBChoc = ((eqtAChoc * element2.positionX) - element2.positionY) / -1
            
            
            
            let eqtA = (el1PrePosY - element1.positionY) / (el1PrePosX - element1.positionX)
            let eqtB = ((eqtA * el1PrePosX) - el1PrePosY) / -1
                       
            let angle = tan((eqtAChoc - eqtA) / (1+(eqtA*eqtAChoc)))
            
            NSLog("eqt1 a")
            NSLog(String(eqtA))
            NSLog("eqt1 b")
            NSLog(String(eqtB))
            
            NSLog("eqt2 a")
            NSLog(String(eqtAChoc))
            NSLog("eqt2 b")
            NSLog(String(eqtBChoc))
            
            NSLog("Angle trouvé")
            NSLog(String(angle))
            NSLog("CONTACTCONTACT")
            
            //Debug
            element1.localSpeedX = 0
            element1.localSpeedY = 0
            
        }
    }
    
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
            self.setNeedsDisplay()
            
            self.playerCircle.checkWallTouch()
            self.collisionChecker(element1: self.playerCircle, element2: self.skittles1)
            //self.collisionChecker(element1: self.playerCircle, element2: self.skittles2)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if alreadyPlayed == false {
            var tmpPoint = touches.first!.location(in: self)
            pointsArray.append(tmpPoint)
            
            if pointsArray.count > 3 {
                var startPoint = pointsArray.first!
                var endPoint = pointsArray.last!
                NSLog("Assez de points pour faire un trajet")
                speedX =  (Float(endPoint.x) - Float(startPoint.x))/4
                speedY =  (Float(endPoint.y) - Float(startPoint.y))/4
                playerCircle.setSpeed(speedToX: speedX, speedToY: speedY)
                loop()
                alreadyPlayed = true
                
            } else {
                NSLog("Pas assez de points pour faire un trajet")
            }
        }
        
    }

}
