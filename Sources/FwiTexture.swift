//  Project name: Texture
//  File name   : FwiTexture.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/14/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public protocol FwiTexture {

    /// Texture's ID.
    var textureID: GLuint { get set }
    var textureUniform: Int32 { get }

    /// Load texture and inject into OpenGLES.
    ///
    /// @param
    /// - filename {String} (a texture's filename)
    mutating func loadTexture(filename f: String)
}

// MARK: FwiTexture's default implementation
public extension FwiTexture where Self: FwiShader {

    public var textureUniform: Int32 {
        return glGetUniformLocation(programID, "u_texture")
    }
    
    public mutating func loadTexture(filename f: String) {
        let option = [GLKTextureLoaderOriginBottomLeft: NSNumber(booleanLiteral: true)]

        guard
            let path = Bundle.main.path(forResource: f, ofType: nil),
            let info = try? GLKTextureLoader.texture(withContentsOfFile: path, options: option)
        else {
            #if DEBUG
                fatalError("Fail to load texture: \(f)!")
            #else
                return
            #endif
        }
        textureID = info.name
    }
}
