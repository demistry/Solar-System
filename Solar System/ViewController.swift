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
        
        sceneView.showsStatistics = true
        sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints, .showPhysicsFields]
        //sceneView.scene.rootNode.addChildNode(sun)

    }
    
    func addAllNodes(nodes : [SCNNode]){
        for node in nodes {
            sceneView.scene.rootNode.addChildNode(node)
        }
        
    }
    
    @IBAction func addSolarSystem(_ sender: UIButton) {
//        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
//            guard !(node.name == "sun") else{
//                print("Node present")
//                return
//            }
//        }
        let presentNodes = sceneView.scene.rootNode.childNodes
        for node in presentNodes{
            if node.name == "Sun Parent Node"{
                print("Node already present, exit scope")
                return
            }
        }
//        presentNodes.map { (node) -> T in
//            guard (node.name == "sun")
//        }
        let pov = sceneView.pointOfView?.position
        let sunParent = SCNNode()
        sunParent.position = pov ?? SCNVector3(0,0,-1)
        sunParent.name = "Sun Parent Node"
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
        sun.position = pov!
        sun.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: 10)))
        sunParent.addChildNode(sun)
        
        let mercury = Planet(radius: 0.1, diffuse: "mercury", specular: nil, normal: nil, emission: nil, position: SCNVector3(0, 0, -0.5))
        let mercuryParent = PlanetParent(position: sun.position, durationOfRotation: 1, childPlanet: mercury)
        
        let venus = Planet(radius: 0.2, diffuse: "venus_surface", specular: nil, normal: nil, emission: "venus_atmosphere", position: SCNVector3(0, 0, -1))
        let venusParent = PlanetParent(position: sun.position, durationOfRotation: 2, childPlanet: venus)
        
        let earth = Planet(radius: 0.3, diffuse: "earth", specular: "earth_specular_map", normal: "earth_normal_map", emission: "earth_clouds", position: SCNVector3(0, 0, -1.7))
        let earthParent = PlanetParent(position: sun.position, durationOfRotation: 3, childPlanet: earth)
        
        addAllNodes(nodes: [sunParent, mercuryParent.parentNode, venusParent.parentNode, earthParent.parentNode])
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
