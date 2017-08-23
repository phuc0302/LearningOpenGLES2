//  Project name: FwiOpenGLES
//  File name   : FwiPixelBufferShader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/22/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public protocol FwiPixelBufferShader {

    /// Texture from pixel buffer.
    var texture: CVOpenGLESTexture? { get set }

    var textureUniform: Int32 { get }
}

// MARK: FwiTextureShader's default implementation
public extension FwiPixelBufferShader where Self: FwiShader {

    public var textureUniform: Int32 {
        return glGetUniformLocation(program, "u_texture")
    }

    public func prepareShader() {
        guard let t = texture else {
            return
        }
        glUseProgram(program)

        // Inject projection matrix uniform
        glUniformMatrix4fv(projectionMatrixUniform, 1, GLboolean(GL_FALSE), projectionMatrix.array)
        // Inject model matrix uniform
        glUniformMatrix4fv(modelMatrixUniform, 1, GLboolean(GL_FALSE), modelMatrix.array)

        // Inject texture uniform
        glActiveTexture(GLenum(GL_TEXTURE0))
        glBindTexture(CVOpenGLESTextureGetTarget(t), CVOpenGLESTextureGetName(t))
        glUniform1i(textureUniform, 0)

        // In case if texture is non power of 2
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MIN_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_MAG_FILTER), GL_LINEAR)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_S), GL_CLAMP_TO_EDGE)
        glTexParameteri(GLenum(GL_TEXTURE_2D), GLenum(GL_TEXTURE_WRAP_T), GL_CLAMP_TO_EDGE)
    }
}
