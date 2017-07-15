//
//  Model.swift
//  Model
//
//  Created by burt on 2016.7. 13..
//  Copyright © 2016년 BurtK. All rights reserved.
//
//  VAO가 있어서 이렇게 정점 및 인덱스 데이터를 모델로 따로 분리할 수 있다.
//  모델 생성시나 렌더링 전 필요한 시기에 VAO를 만들고 정점 및 인덱스 데이터를 
//  CPU에서 GPU로 올리면 된다.

import GLKit


open class FwiGLModel {

    // MARK: Class's properties
    public var scale: Float = 1.0
    public var position = GLKVector3(v: (0.0, 0.0, 0.0))
    public var rotation = GLKVector3(v: (0.0, 0.0, 0.0))

    public var modelMatrix: GLKMatrix4 {
        var modelMatrix = GLKMatrix4Identity

        modelMatrix = GLKMatrix4Translate(modelMatrix, position.x, position.y, position.z)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.x, 1, 0, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.y, 0, 1, 0)
        modelMatrix = GLKMatrix4Rotate(modelMatrix, rotation.z, 0, 0, 1)
        modelMatrix = GLKMatrix4Scale(modelMatrix, scale, scale, scale)

        return modelMatrix
    }

    /// Model's name.
    public fileprivate(set) var name: String
    /// Model's shader.
    public internal(set) var shader: FwiShader
    /// Model's vertices.
    public fileprivate(set) var vertices: [FwiVertex]
    /// Model's list of index of vertex within vertices.
    public fileprivate(set) var indices: [GLubyte]

    /// Model's buffer.
    fileprivate var vao: GLuint = 0
    fileprivate var indexBuffer: GLuint = 0
    fileprivate var vertexBuffer: GLuint = 0

    // MARK: Class's constructors
    init(name n: String, vertices v: [FwiVertex], indices i: [GLubyte], shader s: FwiShader) {
        name = n
        shader = s
        indices = i
        vertices = v


        // Generate 'vertices array object'
        glGenVertexArraysOES(1, &vao)
        glBindVertexArrayOES(vao)

        // Generate 'vertices buffer'
        glGenBuffers(GLsizei(1), &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        let vertexCount = vertices.count
        let vertexSize = MemoryLayout<FwiVertex>.size
        glBufferData(GLenum(GL_ARRAY_BUFFER), vertexCount * vertexSize, vertices, GLenum(GL_STATIC_DRAW))

        // Generate 'indexes buffer'
        glGenBuffers(GLsizei(1), &indexBuffer)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexBuffer)
        let indexCount = indices.count
        let indexSize = MemoryLayout<GLubyte>.size
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER), indexCount * indexSize, indices, GLenum(GL_STATIC_DRAW))


        // Bind data to 'vertices buffer'
        glEnableVertexAttribArray(FwiVertexAttributes.coord)
        glVertexAttribPointer(
            FwiVertexAttributes.coord,
            3,                                                                                      // axis(x, y, z)
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(vertexSize), nil)
        
        // Bind data to 'indexes buffer'
        glEnableVertexAttribArray(FwiVertexAttributes.color)
        glVertexAttribPointer(
            FwiVertexAttributes.color,
            4,                                                                                      // color(r, g, b, a)
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(vertexSize), bufferOffet(3 * MemoryLayout<Float>.size))                         // axis(x, y, z) | color(r, g, b, a) :: offset is 3*sizeof(Float)
        
        // Bind data to 'texture buffer'
        glEnableVertexAttribArray(FwiVertexAttributes.texture)
        glVertexAttribPointer(
            FwiVertexAttributes.texture,
            2,                                                                                      // texture(x, y)
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<FwiVertex>.size), bufferOffet((3 + 4) * MemoryLayout<Float>.size))    // axis(x, y, z) | color(r, g, b, a) | texture(x, y) :: offset is (3+4)*sizeof(Float)

        
        // Bind everything together
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }

    deinit {
        release()
    }

    // MARK: Class's public methods
    /// Release all resources that is binding to this model's instance.
    public func release() {
        glDeleteBuffers(1, &vertexBuffer)
        glDeleteBuffers(1, &indexBuffer)
        glDeleteVertexArrays(1, &vao)
        shader.releaseShader()
    }

    /// Render the model with parent matrix.
    ///
    /// @param
    /// - parentMatrix {GLKMatrix4} (a parent's matrix)
    public func renderModel(withParentMatrix m: GLKMatrix4 = GLKMatrix4MakeTranslation(0, 0, -5)) {
        let matrix = GLKMatrix4Multiply(m, modelMatrix)
        shader.modelMatrix = matrix
        shader.prepareShader()
        
        glBindVertexArrayOES(vao)
        if indices.count % 3 == 0 {
            glDrawElements(GLenum(GL_TRIANGLES), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        } else {
            glDrawElements(GLenum(GL_TRIANGLE_STRIP), GLsizei(indices.count), GLenum(GL_UNSIGNED_BYTE), nil)
        }
        glBindVertexArrayOES(0)
    }

    /// Override point where we need to constantly change model's position & rotation base on time.
    ///
    /// @param
    /// - delta {TimeInterval} (a period of time between previous cycle with current cycle)
    open func update(withDelta dt: TimeInterval) {
    }
}

// MARK: Class's private methods
fileprivate extension FwiGLModel {

    /// Define buffer offset pointer.
    ///
    /// @param
    /// - index
    fileprivate func bufferOffet(_ index: Int) -> UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: index)
    }
}
