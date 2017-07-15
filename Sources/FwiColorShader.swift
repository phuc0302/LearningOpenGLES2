//  Project name: Texture
//  File name   : FwiColorShader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/14/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public struct FwiColorShader: FwiShader {

    // MARK: Class's properties
    public var programID: GLuint = 0
    public var vertexShaderID: GLuint = 0
    public var fragmentShaderID: GLuint = 0

    public var modelMatrix = GLKMatrix4Identity
    public var projectionMatrix = GLKMatrix4Identity

    // MARK: Class's constructors
    public init() {
    }
//    public init(vertexShader: String, fragmentShader: String) {
////        compile()
////        compile(vertexShader: vertexShader, fragmentShader: fragmentShader)
//    }

    // MARK: Class's public methods
    /// Instruct hardware which program to use before rendering the model.
    public func prepareShader() {
        glUseProgram(programID)

        // Inject projection matrix uniform
        glUniformMatrix4fv(projectionMatrixUniform, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        // Inject model matrix uniform
        glUniformMatrix4fv(modelMatrixUniform, 1, GLboolean(GL_FALSE), modelMatrix.array)
    }
}
