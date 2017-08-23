//  Project name: FwiOpenGLES
//  File name   : FwiShaderLoader.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/22/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import GLKit


public protocol FwiShaderLoader {

    /// Create program, compile vertex shader and fragment shader. Then, link vertex shader and
    /// fragment shader to program.
    ///
    /// @param
    /// - vertexShader {String} (a vertex shader's filename)
    /// - fragmentShader {String} (a fragment shader's filename)
    /// - vertexAttributes {[String : UInt32]} (a vertex's attributes to be linked with program)
    /// - bundle {Bundle} (a bundle that contain vertex shader and fragment shader)
    ///
    /// @return
    /// - program {GLuint}
    /// - vertexShader {GLuint}
    /// - fragmentShader {GLuint}
    func compile(vertexShader vertex: String, fragmentShader fragment: String, vertexAttributes attributes: [String:UInt32], fromBundle bundle: Bundle?) -> (GLuint, GLuint, GLuint)

    /// Compile shader for program to link to.
    ///
    /// @param
    /// - shaderName {String} (a shader's name without glsl extension)
    /// - shaderType {GLenum} (a shader's type)
    func compile(shaderName name: String, shaderType type: GLenum, fromBundle bundle: Bundle) -> GLuint
}

// MARK: FwiShaderLoader's default implementation
public extension FwiShaderLoader {

    public func compile(vertexShader vertex: String, fragmentShader fragment: String, vertexAttributes attributes: [String:UInt32] = attributes, fromBundle bundle: Bundle? = nil) -> (GLuint, GLuint, GLuint) {
        let fragmentShader = compile(shaderName: fragment, shaderType: GLenum(GL_FRAGMENT_SHADER), fromBundle: bundle ?? Bundle.main)
        let vertexShader = compile(shaderName: vertex, shaderType: GLenum(GL_VERTEX_SHADER), fromBundle: bundle ?? Bundle.main)
        let program = glCreateProgram()

        glAttachShader(program, fragmentShader)
        glAttachShader(program, vertexShader)

        attributes.forEach { (name, index) in
            glBindAttribLocation(program, index, name)
        }
        glLinkProgram(program)

        var linkStatus: GLint = 0
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)

        /* Condition validation: validate link status */
        if linkStatus == GL_FALSE {
            var length: GLsizei = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &length)

            var info = Array(repeating: GLchar(0), count: Int(length))
            glGetProgramInfoLog(program, length, nil, &info)

            #if DEBUG
                fatalError(String(validatingUTF8: info) ?? "Fail to link vertex shader: \(vertex), fragment shader: \(fragment)!")
            #endif
        }
        return (program, vertexShader, fragmentShader)
    }

    public func compile(shaderName name: String, shaderType type: GLenum, fromBundle bundle: Bundle) -> GLuint {
        /* Condition validation: validate shader's path */
        guard let path = bundle.path(forResource: name, ofType: nil) else {
            #if DEBUG
                fatalError("Could not find shader: \(name)!")
            #else
                return 0
            #endif
        }

        /* Condition validation: validate shader's content */
        guard let shaderString = try? String(contentsOfFile: path, encoding: .utf8) else {
            #if DEBUG
                fatalError("Could not load shader: \(name)!")
            #else
                return 0
            #endif
        }

        // Generate handler
        let handler = glCreateShader(type)
        shaderString.withCString {
            var p: UnsafePointer<Int8>? = $0
            glShaderSource(handler, 1, &p, nil)
        }
        glCompileShader(handler)

        // Compile shader
        var compileStatus: GLint = 0
        glGetShaderiv(handler, GLenum(GL_COMPILE_STATUS), &compileStatus)

        /* Condition validation: validate Compile status */
        if compileStatus == GL_FALSE {
            var length: GLint = 0
            glGetShaderiv(handler, GLenum(GL_INFO_LOG_LENGTH), &length)

            var info = Array(repeating: GLchar(0), count: Int(length))
            glGetShaderInfoLog(handler, length, nil, &info)

            #if DEBUG
                fatalError(String(validatingUTF8: info) ?? "Fail to compile shader: \(name)!")
            #endif
        }
        return handler
    }
}

/// Default vertex attributes
fileprivate let attributes: [String:UInt32] = [
    "a_texture":FwiVertexAttributes.texture,
    "a_color":FwiVertexAttributes.color,
    "a_coord":FwiVertexAttributes.coord
]
