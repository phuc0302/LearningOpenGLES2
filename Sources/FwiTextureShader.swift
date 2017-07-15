//  Project name: Texture
//  File name   : FwiTextureShader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/14/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public struct FwiTextureShader: FwiShader, FwiTexture {

    // MARK: Class's properties
    public var programID: GLuint = 0
    public var vertexShaderID: GLuint = 0
    public var fragmentShaderID: GLuint = 0

    public var modelMatrix = GLKMatrix4Identity
    public var projectionMatrix = GLKMatrix4Identity
    /// Texture.
    public var textureID: GLuint = 0

    // MARK: Class's constructors
    public init(vertexShader: String, fragmentShader: String) {
        self.compile(vertexShader: vertexShader, fragmentShader: fragmentShader)
    }

    //    deinit {
    //        releaseShader()
    //    }

    // MARK: Class's public methods
    /// Instruct hardware which program to use before rendering the model.
    public func prepareShader() {
        glUseProgram(programID)

        // Inject projection matrix uniform
        glUniformMatrix4fv(projectionMatrixUniform, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        // Inject model matrix uniform
        glUniformMatrix4fv(modelMatrixUniform, 1, GLboolean(GL_FALSE), modelMatrix.array)

        // Inject texture uniform
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(GLenum(GL_TEXTURE_2D), textureID)
        glUniform1i(textureUniform, 0)
    }
}
