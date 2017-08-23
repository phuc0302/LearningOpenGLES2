//
//  GLBaseEffect.swift
//  Triangle
//
//  Created by burt on 2017. 7. 12.
//  Copyright © 2016년 BurtK. All rights reserved.
//

import GLKit


public protocol FwiShader {

    /// Program's ID.
    var program: GLuint { get set }

    /// Each program will have exactly 1 vertex shader and 1 fragment shader.
    var vertexShader: GLuint { get set }
    var fragmentShader: GLuint { get set }

    /// Model's matrix in 3D space.
    var modelMatrix: GLKMatrix4 { get }
    var modelMatrixUniform: Int32 { get }

    /// Projection matrix to render 3D model into 2D space.
    var projectionMatrix: GLKMatrix4 { get }
    var projectionMatrixUniform: Int32 { get }

    /// Instruct hardware which program to use before rendering the model.
    func prepareShader()

    /// Release all resources that is binding to this shader's instance.
    func releaseShader()
}

// MARK: FwiShader's default implementation
public extension FwiShader {

    var modelMatrixUniform: Int32 {
        return glGetUniformLocation(program, "modelMatrix")
    }

    var projectionMatrixUniform: Int32 {
        return glGetUniformLocation(program, "projectionMatrix")
    }

    public func prepareShader() {
        glUseProgram(program)

        // Inject projection matrix uniform
        glUniformMatrix4fv(projectionMatrixUniform, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        // Inject model matrix uniform
        glUniformMatrix4fv(modelMatrixUniform, 1, GLboolean(GL_FALSE), modelMatrix.array)
    }

    public func releaseShader() {
        glDetachShader(program, fragmentShader)
        glDetachShader(program, vertexShader)

        glDeleteShader(fragmentShader)
        glDeleteShader(vertexShader)
        glDeleteProgram(program)
    }
}
