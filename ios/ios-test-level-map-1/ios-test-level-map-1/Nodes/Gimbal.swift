//
//  Gimbal.swift
//  ios-test-level-map-1
//
//  Created by Louie on 10/3/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation
import SceneKit

class Gimbal: SCNNode {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        super.init()
        
        let origin = SCNVector3(0, 0, 0)
        let xVector = SCNVector3(1, 0, 0)
        let yVector = SCNVector3(0, 1, 0)
        let zVector = SCNVector3(0, 0, 1)
        
        let originPoint = createCubeObject(color: UIColor.white, size: 0.05)
        originPoint.worldPosition = origin
        
        let xvecPoint = createCubeObject(color: UIColor.red, size: 0.05)
        xvecPoint.worldPosition = xVector
        
        let yvecPoint = createCubeObject(color: UIColor.green, size: 0.05)
        yvecPoint.worldPosition = yVector
        
        let zvecPoint = createCubeObject(color: UIColor.blue, size: 0.05)
        zvecPoint.worldPosition = zVector
        
        self.addChildNode(originPoint)
        self.addChildNode(xvecPoint)
        self.addChildNode(yvecPoint)
        self.addChildNode(zvecPoint)
    }
}
