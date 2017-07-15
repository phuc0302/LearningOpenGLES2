//
//  Vertex.swift
//  Triangle
//
//  Created by burt on 2017. 7. 11.
//  Copyright © 2016년 BurtK. All rights reserved.
//

public struct FwiVertexAttributes {
    public static let color: UInt32   = 0
    public static let coord: UInt32   = 1
    public static let texture: UInt32 = 2
}

public struct FwiVertex {

    // MARK: Struct's properties
    /// Model coordinate.
    public fileprivate(set) var axisX: Float
    public fileprivate(set) var axisY: Float
    public fileprivate(set) var axisZ: Float
    /// Color channel.
    public fileprivate(set) var channelR: Float
    public fileprivate(set) var channelG: Float
    public fileprivate(set) var channelB: Float
    public fileprivate(set) var channelA: Float
    /// Texture coordinate.
    public fileprivate(set) var textureX: Float
    public fileprivate(set) var textureY: Float
    
    // MARK: Struct's constructors
    fileprivate init(_ x: Float, _ y: Float, _ z: Float, _ r: Float = 0.0, _ g: Float = 0.0, _ b: Float = 0.0, _ a: Float = 1.0, _ tX: Float = 0.0, _ tY: Float = 0.0) {
        axisX = x
        axisY = y
        axisZ = z
        
        channelR = r
        channelG = g
        channelB = b
        channelA = a
        
        textureX = tX
        textureY = tY
    }

    fileprivate init(axis: (x: Float, y: Float, z: Float), color: (r: Float, g: Float, b: Float, a: Float) = (0, 0, 0, 1), texture: (x: Float, y: Float) = (0, 0)) {
        self.init(axis.x, axis.y, axis.z, color.r, color.g, color.b, color.a, texture.x, texture.y)
    }
}

// MARK: Struct's constructors
public extension FwiVertex {

    public init(x: Float, y: Float, z: Float) {
        self.init(x, y, z)
    }
}

// MARK: Struct's color constructors
public extension FwiVertex {

    public init(axisCoord: (x: Float, y: Float, z: Float), rgbColor: UInt32) {
        let r = Float((rgbColor & 0xff0000) >> 16) / 255.0
        let g = Float((rgbColor & 0x00ff00) >>  8) / 255.0
        let b = Float(rgbColor  & 0x0000ff) / 255.0

        self.init(axis: axisCoord, color: (r, g, b, 1.0))
    }
    public init(axisCoord: (x: Float, y: Float, z: Float), rgbColor: (r: UInt8, g: UInt8, b: UInt8)) {
        let r = Float(rgbColor.r) / 255.0
        let g = Float(rgbColor.g) / 255.0
        let b = Float(rgbColor.b) / 255.0

        self.init(axis: axisCoord, color: (r, g, b, 1.0))
    }

    public init(axisCoord: (x: Float, y: Float, z: Float), rgbaColor: UInt32) {
        let r = Float((rgbaColor & 0xff000000) >> 24) / 255.0
        let g = Float((rgbaColor & 0x00ff0000) >> 16) / 255.0
        let b = Float((rgbaColor & 0x0000ff00) >>  8) / 255.0
        let a = Float(rgbaColor  & 0x000000ff) / 255.0

        self.init(axis: axisCoord, color: (r, g, b, a))
    }
    public init(axisCoord: (x: Float, y: Float, z: Float), rgbaColor: (r: UInt8, g: UInt8, b: UInt8, a: UInt8)) {
        let r = Float(rgbaColor.r) / 255.0
        let g = Float(rgbaColor.g) / 255.0
        let b = Float(rgbaColor.b) / 255.0
        let a = Float(rgbaColor.a) / 255.0

        self.init(axis: axisCoord, color: (r, g, b, a))
    }
}

// MARK: Struct's texture constructors
public extension FwiVertex {

    public init(axisCoord: (x: Float, y: Float, z: Float), textureCoord: (x: Float, y: Float)) {
        self.init(axis: axisCoord, texture: textureCoord)
    }
}
