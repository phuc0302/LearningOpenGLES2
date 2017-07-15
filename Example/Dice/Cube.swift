//
//  Cube.swift
//  AnimateCube
//
//  Created by burt on 2016. 2. 28..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import GLKit
import FwiOpenGLES


class Cube : FwiGLModel {

    let vertexList : [FwiVertex] = [
        // Front
        FwiVertex(axisCoord:( 1, -1, 1), textureCoord:(0.25, 0)), // 0
        FwiVertex(axisCoord:( 1,  1, 1), textureCoord:(0.25, 0.25)), // 1
        FwiVertex(axisCoord:(-1,  1, 1), textureCoord:(0, 0.25)), // 2
        FwiVertex(axisCoord:(-1, -1, 1), textureCoord:(0, 0)), // 3

        // Back
        FwiVertex(axisCoord:(-1, -1, -1), textureCoord:(0.5, 0)), // 4
        FwiVertex(axisCoord:(-1,  1, -1), textureCoord:(0.5, 0.25)), // 5
        FwiVertex(axisCoord:( 1,  1, -1), textureCoord:(0.25, 0.25)), // 6
        FwiVertex(axisCoord:( 1, -1, -1), textureCoord:(0.25, 0)), // 7

        // Left
        FwiVertex(axisCoord:(-1, -1,  1), textureCoord:(0.75, 0)), // 8
        FwiVertex(axisCoord:(-1,  1,  1), textureCoord:(0.75, 0.25)), // 9
        FwiVertex(axisCoord:(-1,  1, -1), textureCoord:(0.5, 0.25)), // 10
        FwiVertex(axisCoord:(-1, -1, -1), textureCoord:(0.5, 0)), // 11

        // Right
        FwiVertex(axisCoord:( 1, -1, -1), textureCoord:(1, 0)), // 12
        FwiVertex(axisCoord:( 1,  1, -1), textureCoord:(1, 0.25)), // 13
        FwiVertex(axisCoord:( 1,  1,  1), textureCoord:(0.75, 0.25)), // 14
        FwiVertex(axisCoord:( 1, -1,  1), textureCoord:(0.75, 0)), // 15

        // Top
        FwiVertex(axisCoord:( 1,  1,  1), textureCoord:(0.25, 0.25)), // 16
        FwiVertex(axisCoord:( 1,  1, -1), textureCoord:(0.25, 0.5)), // 17
        FwiVertex(axisCoord:(-1,  1, -1), textureCoord:(0, 0.5)), // 18
        FwiVertex(axisCoord:(-1,  1,  1), textureCoord:(0, 0.25)), // 19

        // Bottom
        FwiVertex(axisCoord:( 1, -1, -1), textureCoord:(0.5, 0.25)), // 20
        FwiVertex(axisCoord:( 1, -1,  1), textureCoord:(0.5, 0.5)), // 21
        FwiVertex(axisCoord:(-1, -1,  1), textureCoord:(0.25, 0.5)), // 22
        FwiVertex(axisCoord:(-1, -1, -1), textureCoord:(0.25, 0.25))  // 23
    ]

    let indexList : [GLubyte] = [
        // Front
        0, 1, 2,
        2, 3, 0,
        
        // Back
        4, 5, 6,
        6, 7, 4,
        
        // Left
        8, 9, 10,
        10, 11, 8,
        
        // Right
        12, 13, 14,
        14, 15, 12,
        
        // Top
        16, 17, 18,
        18, 19, 16,
        
        // Bottom
        20, 21, 22,
        22, 23, 20
    ]
    
    init(shader: FwiShader) {
        super.init(name: "cube", vertices: vertexList, indices: indexList, shader: shader)
//        self.loadTexture("dice.png")
    }
    
    override func update(withDelta dt: TimeInterval) {
        rotation.z += (Float(Double.pi*dt) / 16)
        rotation.y += (Float(Double.pi*dt) / 24)
    }

}

