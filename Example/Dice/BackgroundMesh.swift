//  Project name: Dice
//  File name   : BackgroundMesh.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/22/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit
import FwiOpenGLES


final class BackgroundMesh: FwiGLModel, FwiPixelBufferShader {

    // MARK: Class's propertiesz
    /// Texture from pixel buffer.
    var texture: CVOpenGLESTexture?
    let width:  Float = Float(UIScreen.main.bounds.width)
    let height: Float = Float(UIScreen.main.bounds.height)
    // MARK: Class's constructors
    init() {
        let vertices = [
            FwiVertex(axisCoord: (-1.0, -1.0, 0), textureCoord: (1.0, 1.0)),
            FwiVertex(axisCoord: ( 1.0, -1.0, 0), textureCoord: (1.0, 0.0)),
            FwiVertex(axisCoord: (-1.0,  1.0, 0), textureCoord: (0.0, 1.0)),
            FwiVertex(axisCoord: ( 1.0,  1.0, 0), textureCoord: (0.0, 0.0))
        ]

        //        let squareVertices: [GLfloat] = [
        //            0, 0,
        //            w, 0,
        //            0, h,
        //            w, h
        //        ]
        //        let textureVertices: [GLfloat] = [
        //            1, 0,
        //            1, 1,
        //            0, 0,
        //            0, 1
        //        ]
//        let vertices = [
//            FwiVertex(axisCoord: (0.0, 0.0, 0), textureCoord: (1.0, 1.0)),
//            FwiVertex(axisCoord: (width, 0.0, 0), textureCoord: (1.0, 0.0)),
//            FwiVertex(axisCoord: (0.0,  height, 0), textureCoord: (0.0, 1.0)),
//            FwiVertex(axisCoord: (width,  height, 0), textureCoord: (0.0, 0.0))
//        ]
        let indices: [GLubyte] = [0, 1, 2, 3]
        super.init(vertices: vertices, indices: indices)
    }

    deinit {
        releaseShader()
    }

    // MARK: Class's properties
    override var modelMatrix: GLKMatrix4 {
        return GLKMatrix4Identity
    }
    override var projectionMatrix: GLKMatrix4 {
        get {
            return GLKMatrix4Identity
        }
        set {
            // Do nothing
        }
    }

    // MARK: Class's public methods
    override func renderModel(withParentMatrix m: GLKMatrix4 = GLKMatrix4Identity) {
        glDepthMask(GLboolean(GL_FALSE))
        glDisable(GLenum(GL_COLOR_MATERIAL))

        prepareShader()
        super.renderModel(withParentMatrix: m)
    }
}
