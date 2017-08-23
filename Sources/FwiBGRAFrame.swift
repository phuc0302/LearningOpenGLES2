//  Project name: FwiOpenGLES
//  File name   : FwiBGRAFrame.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/18/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public struct FwiBGRAFrame {

    // MARK: Struct's properties
    public let width: Int
    public let height: Int
    public let stride: Int
    public var data: UnsafeMutableRawPointer

    // MARK: Class's constructors
    public init(_ w: Int, _ h: Int, _ s: Int, _ d: UnsafeMutableRawPointer) {
        width  = w
        height = h
        stride = s
        data   = d
    }
}
