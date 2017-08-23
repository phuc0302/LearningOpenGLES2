//  Project name: FwiOpenGLES
//  File name   : FwiParser.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/14/17
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright © 2017 Fiision Studio. All rights reserved.
//  --------------------------------------------------------------

import Foundation


public protocol FwiParser {

    func nextFloat(pointer p: UnsafePointer<UInt8>, index i: Int, decimal d: Double) -> (Int, Double)
}


public extension FwiParser {

    public func nextFloat(pointer p: UnsafePointer<UInt8>, index i: Int, decimal d: Double = 0) -> (Int, Double) {
        return (0, 0.0)
        
//        /* Condition validation: validate end of buffer */
//        guard 0 < index && index < buffer.count else {
//            return (incompleteData, 0)
//        }
//        //        let pointer: UnsafePointer<UInt8>? = nil
//
//        /* Condition validation: terminate recursion */
//        guard buffer[index] != cSpace && buffer[index] != cReturn else {
//            return (index, 0)
//        }
//
//        // Check decimal number
//        var nextDecimal = decimal / 10.0
//        if buffer[index] == cDot {
//            nextDecimal = 0.1
//        }
//
//        /* Condition validation: validate invalid length */
//        let (length, vertex) = recursiveGeometricVertex(&buffer, index + 1, nextDecimal)
//        guard length != incompleteData else {
//            return (incompleteData, 0)
//        }
//
//        if buffer[index] == cMinus {
//            return (length, -vertex)
//        } else if buffer[index] == cDot {
//            return (length, vertex)
//        } else {
//            if decimal != 0 {
//                return (length, (Double(buffer[index] - c0) * decimal + vertex))
//            } else {
//                return (length, (Double(buffer[index] - c0) + vertex))
//            }
//        }
    }
}
