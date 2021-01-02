//
//  GameViewController.swift
//  phonetest5
//
//  Created by Apple1 on 12/7/20.
//

import UIKit
import QuartzCore
import SceneKit
import CoreMotion
import GameplayKit

var PI=Float.pi
var cm=CMMotionManager()

class GameViewController: UIViewController {
    var boxNode=SCNNode()
    var CANode=SCNNode()
    var CMNode=SCNNode()
    var pt:Double=0.0
    var theta=vec3(0.0,0.0,0.0)
    let r1=SCNNode()
    let r2=SCNNode()
    let r3=SCNNode()
    let box=SCNNode()
    let cameraNode = SCNNode()
    let eyedist:Float=1
    var left=true
    let blocker=SCNNode()
    var theta2:Float=0.0
    var thetaEye:Float=0
    override func viewDidLoad() {
        super.viewDidLoad()
        print("bruh")
        cm.startDeviceMotionUpdates()
        
        let scene = SCNScene()
        
        
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
//        thetaEye=atan2(Float(eyedist),4.0)
        
//        cameraNode.localRotate(by:angleAxis(thetaEye,vec3(1.0,0.0,0.0)).toSCNQ())
        
//        blocker.geometry=SCNBox(width:4,height:4,length:1,chamferRadius:0)
//        blocker.position=SCNVector3(x: 0, y: -2, z: -5.5)
//        cameraNode.addChildNode(blocker)
        
        
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: -10, y: 10, z: 10)
        lightNode.look(at: SCNVector3(0,0,0))
        lightNode.light?.castsShadow=true
        scene.rootNode.addChildNode(lightNode)
//        box.addChildNode(lightNode)
        
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        

        r1.geometry=SCNTorus(ringRadius:5,pipeRadius:0.2)
        r1.position = SCNVector3(x: 0, y: 0, z: 0)
        r1.localRotate(by:angleAxis(PI/2,vec3(1.0,0.0,0.0)).toSCNQ())
        scene.rootNode.addChildNode(r1)
        
        

        r2.geometry=SCNTorus(ringRadius:4,pipeRadius:0.2)
        r2.position = SCNVector3(x: 0, y: 0, z: 0)
        r2.localRotate(by:angleAxis(PI/2,vec3(1.0,0.0,0.0)).toSCNQ())
        r1.addChildNode(r2)
        

        r3.geometry=SCNTorus(ringRadius:3,pipeRadius:0.2)
        r3.position = SCNVector3(x: 0, y: 0, z: 0)
        r3.localRotate(by:angleAxis(PI/2,vec3(0.0,0.0,1.0)).toSCNQ())
        r2.addChildNode(r3)
        

        box.geometry=SCNBox(width:3,height:3,length:3,chamferRadius:0)
        box.position=SCNVector3(x: 0, y: 0, z: 0)
        r3.addChildNode(box)
        
//        box.addChildNode(generate())
//        box.addChildNode(lightNode)
        
        let s3=SCNNode()
        s3.geometry=SCNCylinder(radius:0.2,height:6)
        s3.position=SCNVector3(x: 0, y: 0, z: 0)
        s3.localRotate(by:angleAxis(PI/2,vec3(0.0,0.0,1.0)).toSCNQ())
        r3.addChildNode(s3)

        let s2a=SCNNode()
        s2a.geometry=SCNCylinder(radius:0.2,height:1)
        s2a.position=SCNVector3(x:0,y:0,z:3.5)
        s2a.localRotate(by:angleAxis(PI/2,vec3(1.0,0.0,0.0)).toSCNQ())
        r2.addChildNode(s2a)

        let s2b=SCNNode()
        s2b.geometry=SCNCylinder(radius:0.2,height:1)
        s2b.position=SCNVector3(x:0,y:0,z:-3.5)
        s2b.localRotate(by:angleAxis(PI/2,vec3(1.0,0.0,0.0)).toSCNQ())
        r2.addChildNode(s2b)

        let s1a=SCNNode()
        s1a.geometry=SCNCylinder(radius:0.2,height:1)
        s1a.position=SCNVector3(x:4.5,y:0,z:0)
        s1a.localRotate(by:angleAxis(PI/2,vec3(0.0,0.0,1.0)).toSCNQ())
        r1.addChildNode(s1a)

        let s1b=SCNNode()
        s1b.geometry=SCNCylinder(radius:0.2,height:1)
        s1b.position=SCNVector3(x:-4.5,y:0,z:0)
        s1b.localRotate(by:angleAxis(PI/2,vec3(0.0,0.0,1.0)).toSCNQ())
        r1.addChildNode(s1b)

        
        let scnView = self.view as! SCNView
        scnView.delegate=self
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.black
        
        r1.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x:0,y:0,z:0,duration: 1)))
        boxNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x:0,y:0,z:0,duration: 1)))
        CANode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0,y:0,z:0,duration: 1)))
        CMNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0,y:0,z:0,duration: 1)))
                                    
    }
    func generate()->SCNNode{
        var root=SCNNode()
        var w:Float=1.0,gridSize=40
        root.localRotate(by:angleAxis(PI/2,vec3(0.0,0.0,1.0)).toSCNQ())
        root.position=SCNVector3(x: 0, y: 0, z: 0)
        let nm=GKNoiseMap(GKNoise(GKPerlinNoiseSource()))
        for i in 0..<gridSize{
            for j in 0..<gridSize{
                let k=Int(10*nm.value(at:SIMD2<Int32>(Int32(i),Int32(j))))
                let block=SCNNode()
                block.geometry=SCNBox(width:3,height:3,length:3,chamferRadius:0)
                block.position=SCNVector3(x: 3*Float(i-gridSize/2), y: 3*Float(-7+k), z: 3*Float(j-gridSize/2))
                root.addChildNode(block)
            }
        }
        return root
    }
    override var shouldAutorotate: Bool {
        return false
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}


extension GameViewController:SCNSceneRendererDelegate{
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        if(left){
//            cameraNode.position = SCNVector3(x: 0, y: Float(eyedist/2), z: 15)
//            cameraNode.localRotate(by:angleAxis(-2.0*thetaEye,vec3(1.0,0.0,0.0)).toSCNQ())
//            blocker.position=SCNVector3(x: 0, y: -2, z: -5.5)
//        }else{
//            cameraNode.position = SCNVector3(x: 0, y: -Float(eyedist/2), z: 15)
//            cameraNode.localRotate(by:angleAxis(
//                                2.0*thetaEye,vec3(1.0,0.0,0.0)).toSCNQ())
//            blocker.position=SCNVector3(x: 0, y: 2, z: -5.5)
//        }
//        left = !left
        
        
        let dm=cm.deviceMotion
        
        let gx:Double=dm?.rotationRate.x ?? 0
        let gy:Double=dm?.rotationRate.y ?? 0
        let gz:Double=dm?.rotationRate.z ?? 0
        
        let mx:Double=dm?.magneticField.field.x ?? 0
        let my:Double=dm?.magneticField.field.y ?? 0
        let mz:Double=dm?.magneticField.field.z ?? 0
        
        let ax:Double=dm?.gravity.x ?? 0
        let ay:Double=dm?.gravity.y ?? 0
        let az:Double=dm?.gravity.z ?? 0
                
        let gyro=vec3(gx,gy,gz)
        let acc=vec3(ax,ay,az)
        let m=vec3(mx,my,mz).normalize()

        let dt:Float=Float(time-pt)
        pt=time
        let dthetadt=gyro
        
        let dtheta1dt = -dthetadt.x
        let dtheta2dt = +dthetadt.y*sin(theta.x)+dthetadt.z*cos(theta.x)
        let dtheta3dt = +dthetadt.y*cos(theta.x)*cos(theta2)+dthetadt.z*sin(-theta.x)*cos(theta2)
        
        let q1=angleAxis(dtheta1dt*dt,vec3(1.0,0.0,0.0))
        r2.localRotate(by:q1.toSCNQ())
        let q2=angleAxis(dtheta2dt*dt,vec3(0.0,0.0,1.0))
        r3.localRotate(by:q2.toSCNQ())
        let q3=angleAxis(dt*dtheta3dt,vec3(1.0,0.0,0.0))
        box.localRotate(by:q3.toSCNQ())
        
        theta2=theta2+dtheta2dt*dt
        theta=theta+dthetadt*dt
    }
}
