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
    var programID: GLuint { get set }

    /// Each program will have exactly 1 vertex shader and 1 fragment shader.
    var vertexShaderID: GLuint { get set }
    var fragmentShaderID: GLuint { get set }

    /// Model's matrix in 3D space.
    var modelMatrix: GLKMatrix4 { get set }
    /// Projection matrix to render 3D model into 2D space.
    var projectionMatrix: GLKMatrix4 { get set }

    /// Uniform's info to inject model matrix & projection matrix into hardware
    var modelMatrixUniform: Int32 { get }
    var projectionMatrixUniform: Int32 { get }


    /// Create program, compile vertex shader and fragment shader. Then, link vertex shader and
    /// fragment shader to program.
    ///
    /// @param
    /// - vertexShader {String} (a vertex shader's name without glsl extension)
    /// - fragmentShader {String} (a fragment shader's name without glsl extension)
    mutating func compile(vertexShader vertex: String, fragmentShader fragment: String)

    /// Instruct hardware which program to use before rendering the model.
    func prepareShader()

    /// Release all resources that is binding to this shader's instance.
    func releaseShader()
}

// MARK: FwiShader's default implementation
public extension FwiShader {

    var modelMatrixUniform: Int32 {
        return glGetUniformLocation(programID, "modelMatrix")
    }

    var projectionMatrixUniform: Int32 {
        return glGetUniformLocation(programID, "projectionMatrix")
    }

    public mutating func compile(vertexShader vertex: String, fragmentShader fragment: String) {
        fragmentShaderID = compile(shaderName: fragment, shaderType: GLenum(GL_FRAGMENT_SHADER))
        vertexShaderID = compile(shaderName: vertex, shaderType: GLenum(GL_VERTEX_SHADER))
        programID = glCreateProgram()

        glAttachShader(programID, fragmentShaderID)
        glAttachShader(programID, vertexShaderID)

        glBindAttribLocation(programID, FwiVertexAttributes.texture, "a_texture")
        glBindAttribLocation(programID, FwiVertexAttributes.color, "a_color")
        glBindAttribLocation(programID, FwiVertexAttributes.coord, "a_coord")
        glLinkProgram(programID)

        var linkStatus : GLint = 0
        glGetProgramiv(programID, GLenum(GL_LINK_STATUS), &linkStatus)

        /* Condition validation: validate link status */
        if linkStatus == GL_FALSE {
            var length: GLsizei = 0
            glGetProgramiv(programID, GLenum(GL_INFO_LOG_LENGTH), &length)

            var info = Array(repeating: GLchar(0), count: Int(length))
            glGetProgramInfoLog(programID, length, nil, &info)

            #if DEBUG
                fatalError(String(validatingUTF8: info) ?? "Fail to link vertex shader: \(vertex), fragment shader: \(fragment)!")
            #else
                releaseShader()
            #endif
        }
    }

    public func releaseShader() {
        glDetachShader(programID, fragmentShaderID)
        glDetachShader(programID, vertexShaderID)

        glDeleteShader(fragmentShaderID)
        glDeleteShader(vertexShaderID)
        glDeleteProgram(programID)
    }

    // MARK: Class's private methods
    /// Compile shader for program to link to.
    ///
    /// @param
    /// - shaderName {String} (a shader's name without glsl extension)
    /// - shaderType {GLenum} (a shader's type)
    fileprivate func compile(shaderName name: String, shaderType type: GLenum) -> GLuint {
        /* Condition validation: validate shader's path */
        guard let path = Bundle.main.path(forResource: name, ofType: "glsl") else {
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
