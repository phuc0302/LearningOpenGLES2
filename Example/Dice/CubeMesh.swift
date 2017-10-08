//
//  Cube.swift
//  AnimateCube
//
//  Created by burt on 2016. 2. 28..
//  Copyright © 2016년 BurtK. All rights reserved.
//

import GLKit
import FwiOpenGLES


final class CubeMesh : FwiGLModel, FwiTextureShader {

    // MARK: Class's properties
    var texture: GLuint = 0

    // MARK: Class's constructors
    init() {
        let vertices : [FwiVertex] = [
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

        let indices : [GLubyte] = [
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
        super.init(vertices: vertices, indices: indices)

//        let r = GLKVector3(v: (GLKMathDegreesToRadians(150),
//                               GLKMathDegreesToRadians(81),
//                               GLKMathDegreesToRadians(19)))
//        rotation = r

//        let t = GLKVector3(v: (Float(12 / UIScreen.main.bounds.width), Float(12 / UIScreen.main.bounds.height), 12))
//        position = t
    }

    // MARK: Class's destructors
    deinit {
        glDeleteTextures(1, &texture)
    }

//    override var modelMatrix: GLKMatrix4 {
//        let m = GLKMatrix4(m: (-0.545976,
//                               -0.787525,
//                               0.285858,
//                               0,
//                               0.715503,
//                               -0.615799,
//                               -0.329918,
//                               0,
//                               0.43585,
//                               0.024405,
//                               0.899688,
//                               0,
//                               -1.03159,
//                               -0.304708,
//                               -18.2006,
//                               1))
//        return m
//        //        return GLKMatrix4Multiply(parentMatrix, m)
//    }
    override var modelMatrix: GLKMatrix4 {
        let m = GLKMatrix4(m: (0.732164,
            0.0953958,
            0.674415,
            0,
            -0.327057,
            0.917768,
            0.225244,
            0,
            -0.59747,
            -0.385488,
            0.703156,
            0,
            0.890563,
            -0.236327,
            -12.3431,
            1))
        return m
        //        return GLKMatrix4Multiply(parentMatrix, m)
    }

    // MARK: Class's public methods
    override func renderModel(withParentMatrix m: GLKMatrix4 = GLKMatrix4MakeTranslation(0, 0, -5)) {
        glDepthMask(GLboolean(GL_TRUE))
        glEnable(GLenum(GL_DEPTH_TEST))

        parentMatrix = m
        prepareShader()
        super.renderModel(withParentMatrix: m)
    }

    override func update(withDelta dt: TimeInterval) {
        rotation.z += (Float(Double.pi*dt) / 16)
        rotation.y += (Float(Double.pi*dt) / 24)
    }

}

