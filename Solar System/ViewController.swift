//
//  ViewController.swift
//  Solar System
//
//  Created by David Ilenwabor on 14/05/2019.
//  Copyright © 2019 Davidemi. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        // Show statistics such as fps and timing information
        
        let earthParent = SCNNode()
        earthParent.position = SCNVector3(0,0,-2)
        
        let moon = SCNNode(geometry: SCNSphere(radius: 0.1))
        moon.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "moon")
        moon.position = SCNVector3(0,0,-1)
        
        let earth = SCNNode(geometry: SCNSphere(radius: 0.3))
        earth.position = SCNVector3(0,0,-2)
        earth.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        earth.geometry?.firstMaterial?.specular.contents = UIImage(named: "earth_specular_map")
        earth.geometry?.firstMaterial?.normal.contents = UIImage(named: "earth_normal_map")
        earth.geometry?.firstMaterial?.emission.contents = UIImage(named: "earth_clouds")
        let rotationaction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: 4))
        let moonRotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: 12))
        earthParent.runAction(moonRotation)
        earth.runAction(rotationaction)
        earthParent.addChildNode(moon)
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints, .showPhysicsFields]
        sceneView.scene.rootNode.addChildNode(earth)
        sceneView.scene.rootNode.addChildNode(earthParent)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

extension Int {
    
    var degreesToRadians: CGFloat { return CGFloat(Double(self) * .pi/180)}
}
