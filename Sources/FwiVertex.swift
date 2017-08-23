//
//  Vertex.swift
//  Triangle
//
//  Created by burt on 2017. 7. 11.
//  Copyright © 2016년 BurtK. All rights reserved.
//

public struct FwiVertexAttributes {
    public static let color: UInt32 = 0
    public static let coord: UInt32 = 1
    public static let texture: UInt32 = 2
}


public struct FwiVertex {

    /// Model coordinate.
    public fileprivate(set) var x: Float
    public fileprivate(set) var y: Float
    public fileprivate(set) var z: Float
    /// Color channel.
    public fileprivate(set) var r: Float
    public fileprivate(set) var g: Float
    public fileprivate(set) var b: Float
    public fileprivate(set) var a: Float
    /// Texture coordinate.
    public fileprivate(set) var tX: Float
    public fileprivate(set) var tY: Float
    
    // MARK: Struct's constructors
    fileprivate init(_ x: Float, _ y: Float, _ z: Float, _ r: Float = 0.0, _ g: Float = 0.0, _ b: Float = 0.0, _ a: Float = 1.0, _ tX: Float = 0.0, _ tY: Float = 0.0) {
        self.x = x
        self.y = y
        self.z = z
        
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        
        self.tX = tX
        self.tY = tY
    }
}

// MARK: Struct's constructors
public extension FwiVertex {

    public init(x: Float, y: Float) {
        self.init(x, y, 0)
    }

    public init(x: Float, y: Float, z: Float) {
        self.init(x, y, z)
    }
}

// MARK: Struct's color constructors
public extension FwiVertex {

    public init(axisCoord: (Float, Float, Float), rgbColor: UInt32) {
        let r = Float((rgbColor & 0xff0000) >> 16) / 255.0
        let g = Float((rgbColor & 0x00ff00) >>  8) / 255.0
        let b = Float(rgbColor  & 0x0000ff) / 255.0
        self.init(axisCoord.0, axisCoord.1, axisCoord.2, r, g, b)
    }
    public init(axisCoord: (Float, Float, Float), rgbColor: (UInt8, UInt8, UInt8)) {
        let r = Float(rgbColor.0) / 255.0
        let g = Float(rgbColor.1) / 255.0
        let b = Float(rgbColor.2) / 255.0
        self.init(axisCoord.0, axisCoord.1, axisCoord.2, r, g, b)
    }

    public init(axisCoord: (Float, Float, Float), rgbaColor: UInt32) {
        let r = Float((rgbaColor & 0xff000000) >> 24) / 255.0
        let g = Float((rgbaColor & 0x00ff0000) >> 16) / 255.0
        let b = Float((rgbaColor & 0x0000ff00) >>  8) / 255.0
        let a = Float(rgbaColor  & 0x000000ff) / 255.0
        self.init(axisCoord.0, axisCoord.1, axisCoord.2, r, g, b, a)
    }
    public init(axisCoord: (Float, Float, Float), rgbaColor: (UInt8, UInt8, UInt8, UInt8)) {
        let r = Float(rgbaColor.0) / 255.0
        let g = Float(rgbaColor.1) / 255.0
        let b = Float(rgbaColor.2) / 255.0
        let a = Float(rgbaColor.3) / 255.0
        self.init(axisCoord.0, axisCoord.1, axisCoord.2, r, g, b, a)
    }
}

// MARK: Struct's texture constructors
public extension FwiVertex {

    public init(axisCoord: (Float, Float, Float), textureCoord: (Float, Float)) {
        self.init(axisCoord.0, axisCoord.1, axisCoord.2, 0, 0, 0, 1.0, textureCoord.0, textureCoord.1)
    }
}
