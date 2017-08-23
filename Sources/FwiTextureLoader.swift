//  Project name: Texture
//  File name   : FwiTextureLoader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 7/14/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 BurtK. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public protocol FwiTextureLoader {

    /// Load texture and inject into OpenGLES.
    ///
    /// @param
    /// - filename {String} (a texture's filename)
    func loadTexture(filename f: String) -> GLuint
}

// MARK: FwiTexture's default implementation
public extension FwiTextureLoader {

    public func loadTexture(filename f: String) -> GLuint {
        let option = [GLKTextureLoaderOriginBottomLeft: NSNumber(booleanLiteral: true)]
        guard let path = Bundle.main.path(forResource: f, ofType: nil) else {
            return 0
        }

        do {
            let info = try GLKTextureLoader.texture(withContentsOfFile: path, options: option)
            return info.name
        } catch let err as NSError {
            #if DEBUG
                fatalError("Fail to load texture: \(f)! (\(err.localizedDescription))")
            #else
                return 0
            #endif
        }
    }
}
