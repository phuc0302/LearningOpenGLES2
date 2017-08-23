//  Project name: FwiOpenGLES
//  File name   : FwiPixelBufferLoader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/23/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public protocol FwiPixelBufferLoader {

    /// Texture cache.
    var textureCache: CVOpenGLESTextureCache? { get }

    /// Convert pixel buffer into texture.
    ///
    /// @params
    /// - pixelBuffer {CVPixelBuffer} (a pixel buffer, can be from camera or video)
    func bind(pixelBuffer buffer: CVPixelBuffer?) -> CVOpenGLESTexture?

    /// Flush everything from cache.
    func flush()
}

// MARK: FwiTextureShader's default implementation
public extension FwiPixelBufferLoader {

    public func bind(pixelBuffer buffer: CVPixelBuffer?) -> CVOpenGLESTexture? {
        guard let pixelBuffer = buffer, let cache = textureCache else {
            return nil
        }

        // Convert pixel buffer into texture
        let height = CVPixelBufferGetHeight(pixelBuffer)
        let width = CVPixelBufferGetWidth(pixelBuffer)

        var texture: CVOpenGLESTexture? = nil
        defer {
            texture = nil
        }
        let err: CVReturn = CVOpenGLESTextureCacheCreateTextureFromImage(
            kCFAllocatorDefault,
            cache,
            pixelBuffer,
            nil,
            GLenum(GL_TEXTURE_2D),
            GL_RGBA,
            GLsizei(width),
            GLsizei(height),
            GLenum(GL_BGRA),
            UInt32(GL_UNSIGNED_BYTE),
            0,
            &texture
        )

        // Return result
        if err != kCVReturnSuccess {
            debugPrint("There was an error during binding new pixel buffer \(err)!")
        }
        return texture
    }

    public func flush() {
        guard let cache = textureCache else {
            return
        }
        CVOpenGLESTextureCacheFlush(cache, 0)
    }
}
