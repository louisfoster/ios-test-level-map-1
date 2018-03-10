//
//  Map.swift
//  ios-test-level-map-1
//
//  Created by Louie on 9/3/18.
//  Copyright © 2018 Louis Foster. All rights reserved.
//

import Foundation
import SceneKit

class Map: SCNNode {
    
    // Properties
    
    private var map: Array<Int>
    private var mapWidth: Int
    private var mapHeight: Int
    
    // MARK: Initialiser
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override init() {
        
        self.map = [
        
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 1, 0,
            0, 0, 0, 1, 0,
            0, 0, 0, 0, 0
        
        ]
        
        self.mapWidth = 5
        self.mapHeight = 5
        
        super.init()
        
        self.position = SCNVector3(x: 0.5, y: 0, z: -0.5)
        self.mapToObjects()
    }
    
    func mapToObjects() {
        
        for row in 0..<self.mapHeight {
            
            for column in 0..<self.mapWidth {
                
                let matrixPosition = column + (row * self.mapWidth)
                    
                if self.map[matrixPosition] == 0 {
                
                    self.addChildNode(self.createPlaneObject(x: Float(column), y: 0, z: Float(-row)))
                }
                else {
                    
                    self.addChildNode(self.createBoxObject(x: Float(column), y: 0.5, z: Float(-row)))
                }
            }
        }
    }
    
    func createPlaneObject(x: Float, y: Float, z: Float) -> SCNNode {
        
        let planeGeometry = SCNPlane(width: 1, height: 1)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIImage(named: "art.scnassets/texture.png")
        planeMaterial.diffuse.wrapS = .repeat
        planeMaterial.diffuse.wrapT = .repeat
        planeGeometry.firstMaterial = planeMaterial
        
        let plane = SCNNode(geometry: planeGeometry)
        plane.position = SCNVector3(x, y, z)
        let rotateBy = -90 / 180 * Double.pi // Angle to make plane flat
        plane.rotation = SCNVector4(1, 0, 0, rotateBy)
        
        return plane
    }
    
    func createBoxObject(x: Float, y: Float, z: Float) -> SCNNode {
        
        let boxGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.blue
        boxGeometry.firstMaterial = boxMaterial
        
        let box = SCNNode(geometry: boxGeometry)
        box.position = SCNVector3(x, y, z)
        
        return box
    }
}
