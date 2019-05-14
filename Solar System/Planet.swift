//
//  Planet.swift
//  Solar System
//
//  Created by David Ilenwabor on 14/05/2019.
//  Copyright © 2019 Davidemi. All rights reserved.
//

import Foundation
import ARKit

class Planet{
    
    var planetNode : SCNNode
    
    init(radius : CGFloat, diffuse : String, specular : String?, normal : String?, emission : String?, position : SCNVector3) {
        planetNode = SCNNode(geometry: SCNSphere(radius: radius))
        planetNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: diffuse)
        planetNode.geometry?.firstMaterial?.specular.contents = UIImage(named: specular ?? "")
        planetNode.geometry?.firstMaterial?.normal.contents = UIImage(named: normal ?? "")
        planetNode.geometry?.firstMaterial?.emission.contents = UIImage(named: emission ?? "")
        planetNode.position = position
        //let foreverAction =
    }}


class PlanetParent{
    var parentNode : SCNNode
    private var rotationAction : SCNAction
    
    init(position : SCNVector3, durationOfRotation : TimeInterval, childPlanet : Planet) {
        parentNode = SCNNode()
        parentNode.position = position
        rotationAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 360.degreesToRadians, z: 0, duration: durationOfRotation))
        parentNode.runAction(rotationAction)
        parentNode.addChildNode(childPlanet.planetNode)
    }
}


