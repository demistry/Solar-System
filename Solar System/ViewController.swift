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
        //sceneView.debugOptions = [.showWorldOrigin, .showFeaturePoints, .showPhysicsFields]
        //sceneView.scene.rootNode.addChildNode(sun)

    }
    
    func addAllNodes(nodes : [SCNNode]){
        for node in nodes {
            sceneView.scene.rootNode.addChildNode(node)
            
        }
        
    }
    
    @IBAction func addSolarSystem(_ sender: UIButton) {
        let presentNodes = sceneView.scene.rootNode.childNodes
        for node in presentNodes{
            if node.name == "Sun Parent Node"{
                print("Node already present, exit scope")
                return
            }
        }

        let pov = sceneView.pointOfView?.position
        //let z = pov!.z - 0.5
        let positionOfSun = SCNVector3(0, 0, 0)
        let sunParent = SCNNode()
//        sunParent.position = pov ?? SCNVector3(0,0,-3)
        sunParent.position = positionOfSun
        sunParent.name = "Sun Parent Node"
        let sun = SCNNode(geometry: SCNSphere(radius: 0.1))
        sun.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "sun")
        sun.position = positionOfSun
        
        sun.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: 10)))
        sunParent.addChildNode(sun)
        
        let mercury = Planet(radius: 0.02, diffuse: "mercury", specular: nil, normal: nil, emission: nil, position: SCNVector3(-0.6, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 0.6))
        let mercuryParent = PlanetParent(position: positionOfSun, durationOfRotation: 2.5, childPlanet: mercury)
        
        let venus = Planet(radius: 0.04, diffuse: "venus_surface", specular: nil, normal: nil, emission: "venus_atmosphere", position: SCNVector3(-0.8, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 0.8))
        let venusParent = PlanetParent(position: positionOfSun, durationOfRotation: 4, childPlanet: venus)
        
        let earth = Planet(radius: 0.05, diffuse: "earth", specular: "earth_specular_map", normal: "earth_normal_map", emission: "earth_clouds", position: SCNVector3(-1, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 1))
        let earthParent = PlanetParent(position: positionOfSun, durationOfRotation: 7, childPlanet: earth)
        
        let mars = Planet(radius: 0.03, diffuse: "mars", specular: nil, normal: nil, emission: nil, position: SCNVector3(-1.3, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 1.3))
        let marsParent = PlanetParent(position: positionOfSun, durationOfRotation: 9, childPlanet: mars)
        
        let jupiter = Planet(radius: 0.15, diffuse: "jupiter", specular: nil, normal: nil, emission: nil, position: SCNVector3(-1.7, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 1.7))
        let jupiterParent = PlanetParent(position: positionOfSun, durationOfRotation: 11, childPlanet: jupiter)
        
        
        //TODO:- Add a ring for saturn
        
        
        
        let saturn = Planet(radius: 0.12, diffuse: "saturn", specular: nil, normal: nil, emission: nil, position: SCNVector3(-1.9, 0, 0))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.141))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.145))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.151))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.155))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.16))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.159))
        saturn.planetNode.addChildNode(createSaturnRings(distance: 0.143))
        sunParent.addChildNode(addOrbit(distance: 1.9))
        let saturnParent = PlanetParent(position: positionOfSun, durationOfRotation: 13, childPlanet: saturn)
        
        let uranus = Planet(radius: 0.09, diffuse: "uranus", specular: nil, normal: nil, emission: nil, position: SCNVector3(-2.1, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 2.1))
        let uranusParent = PlanetParent(position: positionOfSun, durationOfRotation: 14, childPlanet: uranus)
        
        let neptune = Planet(radius: 0.08, diffuse: "neptune", specular: nil, normal: nil, emission: nil, position: SCNVector3(-2.3, 0, 0))
        sunParent.addChildNode(addOrbit(distance: 2.3))
        let neptuneParent = PlanetParent(position: positionOfSun, durationOfRotation: 16, childPlanet: neptune)
        
        
        
        
        addAllNodes(nodes: [sunParent, mercuryParent.parentNode, venusParent.parentNode, earthParent.parentNode,marsParent.parentNode, jupiterParent.parentNode, saturnParent.parentNode, uranusParent.parentNode, neptuneParent.parentNode])
    }
    
    func createSaturnRings(distance : CGFloat) -> SCNNode{
        let saturnRing = SCNNode(geometry: SCNTorus(ringRadius: distance, pipeRadius: 0.01))
        saturnRing.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "saturn_ring_alpha")
        saturnRing.eulerAngles = SCNVector3(-45.degreesToRadians, 45.degreesToRadians, 0)
        saturnRing.position = SCNVector3(0, 0, 0)
        return saturnRing
    }
    
    func addOrbit(distance : Double)->SCNNode{
        let oribitNode = SCNNode()
        oribitNode.position = SCNVector3(0, 0, 0)
        
        let ringRadius = distance
        oribitNode.geometry = SCNTorus(ringRadius: CGFloat(ringRadius), pipeRadius: 0.001)
        oribitNode.geometry?.firstMaterial?.multiply.contents = UIColor.lightGray
        return oribitNode
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
