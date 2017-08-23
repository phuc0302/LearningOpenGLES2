//  Project name: FwiOpenGLES
//  File name   : FwiOBJParser.swift
//
//  Author      : Phuc, Tran Huu
//  Created date: 8/5/17
//  Version     : 1.00
//  --------------------------------------------------------------
//
//  --------------------------------------------------------------

import Foundation


fileprivate let cReturn: UInt8 = 10  // '\n'
fileprivate let cSpace: UInt8  = 32  // ' '
fileprivate let cHash: UInt8   = 35  // '#'
fileprivate let cMinus: UInt8  = 45  // '-'
fileprivate let cDot: UInt8    = 46  // '.'
fileprivate let cSlash: UInt8  = 47  // '/'
fileprivate let c0: UInt8      = 48  // '0'
fileprivate let c1: UInt8      = 49  // '1'
fileprivate let c2: UInt8      = 50  // '2'
fileprivate let c3: UInt8      = 51  // '3'
fileprivate let c4: UInt8      = 52  // '4'
fileprivate let c5: UInt8      = 53  // '5'
fileprivate let c6: UInt8      = 54  // '6'
fileprivate let c7: UInt8      = 55  // '7'
fileprivate let c8: UInt8      = 56  // '8'
fileprivate let c9: UInt8      = 57  // '9'
fileprivate let cB: UInt8      = 98  // 'b'
fileprivate let cE: UInt8      = 101 // 'e'
fileprivate let cF: UInt8      = 102 // 'f'
fileprivate let cG: UInt8      = 103 // 'g'
fileprivate let cI: UInt8      = 105 // 'i'
fileprivate let cL: UInt8      = 108 // 'l'
fileprivate let cM: UInt8      = 109 // 'm'
fileprivate let cN: UInt8      = 110 // 'n'
fileprivate let cP: UInt8      = 112 // 'p'
fileprivate let cS: UInt8      = 115 // 's'
fileprivate let cT: UInt8      = 116 // 't'
fileprivate let cU: UInt8      = 117 // 'u'
fileprivate let cV: UInt8      = 118 // 'v'


//File Organization
//
//OBJ files do not require any sort of header, although it is common to begin the file with a comment line of some kind. Comment lines begin with a hash mark (#). Blank space and blank lines can be freely added to the file to aid in formatting and readability. Each non-blank line begins with a keyword and may be followed on the same line with the data for that keyword. Lines are read and processed until the end of the file. Lines can be logically joined with the line continuation character ( \ ) at the end of a line.
//
//The following keywords may be included in an OBJ file. In this list, keywords are arranged by data type, and each is followed by a brief description and the format of a line.
//
//Vertex data:
//
//v     Geometric vertices:                 v x y z
//vt   Texture vertices:                     vt u v
//vn   Vertex normals:                      vn dx dy dz
//
//Elements:
//
//p    Point:                                      p v1
//l     Line:                                       l v1 v2 ... vn
//f     Face:                                       f v1 v2 ... vn
//f     Face with texture coords:       f v1/t1 v2/t2 .... vn/tn
//f     Face with vertex normals:      f v1//n1 v2//n2 .... vn//nn
//f     Face with txt and norms:        f v1/t1/n1 v2/t2/n2 .... vn/tn/nn
//
//Grouping:
//
//g     Group name:                           g groupname
//
//Display/render attributes:
//
//usemtl     Material name:           usemtl materialname
//mtllib     Material library:          mtllib materiallibname.mtl

fileprivate let incompleteBuffer = -1
fileprivate let incompleteData = -2


public struct FwiOBJParser: FwiParser {

    // MARK: Class's properties
    fileprivate let stream: InputStream

    fileprivate var isComment = false
    fileprivate var isGroup = false

    // MARK: Class's constructors
    public init(path p: String?) throws {
        guard let p = p, let inputStream = InputStream(fileAtPath: p) else {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's path!"])
        }
        stream = inputStream
    }

    // MARK: Class's public methods
    public mutating func parse() throws {
        stream.open()
        defer { stream.close() }

        var buffer = [UInt8](repeating: 0, count: 256)
        var remain = 0

        while stream.hasBytesAvailable {
            var length = stream.read(&buffer[remain], maxLength: (buffer.count - remain))
            var beginLine = 0
            length += remain

            var i = 0
            repeat {
                // Process the rest
                switch buffer[i] {
                case cHash:
                    let length = parseComment(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

                case cF:
                    let length = try validateFace(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

                case cG:
                    let (length, groupName) = try validateGroup(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

                case cM:
                    let (length, mtllib) = try validateMaterialLibrary(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

                case cV:
                    let length = try validateVertex(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

                case cU:
                    let (length, text) = try validateMaterialName(&buffer, i)
                    if length == incompleteBuffer {
                        i = buffer.count
                    } else {
//                        debugPrint(text)
                        i = length
                        beginLine = (i + 1)
                    }

//                case cL:
//                    // Begin of line
//                    break

//                case cP:
//                    // Begin of point
//                    break

//                case cS:
//                    // Begin of smooth shading
//                    break
                    
                default:
                    break
                }

                i += 1
            } while i < length

            // Process remaining bytes
            if beginLine < length {
                moveRemainBytes(&buffer, beginLine, 0, length)
                remain = length - beginLine
            } else {
                remain = 0
            }
        }
    }
}

// MARK: Parse comment
fileprivate extension FwiOBJParser {

    fileprivate func parseComment(_ buffer: inout [UInt8], _ index: Int) -> Int {
        /* Condition validation: validate end of buffer */
        guard index < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cReturn else {
            return index
        }
        return parseComment(&buffer, index + 1)
    }
}

// MARK: Parse face
fileprivate extension FwiOBJParser {

    fileprivate func validateFace(_ buffer: inout [UInt8], _ index: Int) throws -> Int {
        /* Condition validation: validate index out of bound */
        guard index + 1 < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: validate next byte(s) */
        if buffer[index + 1] != cSpace {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's face!"])
        }

        let (l1, v1, vt1, vn1) = recursiveFace(&buffer, index + 2)
        let (l2, v2, vt2, vn2) = recursiveFace(&buffer, l1 + 1)
        let (l3, v3, vt3, vn3) = recursiveFace(&buffer, l2 + 1)
        let length = l3

//        #if DEBUG_PARSER
//            let text1 = String(format: "f %d/%d %d/%d %d/%d", v1, vt1, v2, vt2, v3, vt3)
//            let text2 = String(bytesNoCopy: &buffer[index], length: (length - index), encoding: .utf8, freeWhenDone: false)
//
//            if text1 != text2 && l1 != incompleteData && l2 != incompleteData && l3 != incompleteData {
//                debugPrint("Expected \(String(describing: text2)) but found: \(text1)")
//            }
//        #endif
        return length > 0 ? length : incompleteBuffer
    }

    fileprivate func recursiveFace(_ buffer: inout [UInt8], _ index: Int, _ slashCounter: Int = 0, _ vertexIndex: Int = 0, _ textureIndex: Int = 0, _ normalIndex: Int = 0) -> (Int, Int, Int, Int) {
        /* Condition validation: validate end of buffer */
        guard 0 < index && index < buffer.count else {
            return (incompleteData, 0, 0, 0)
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cSpace && buffer[index] != cReturn else {
            return (index, vertexIndex, textureIndex, normalIndex)
        }

        /* Condition validation: next value */
        guard buffer[index] != cSlash else {
            return recursiveFace(&buffer, index + 1, slashCounter + 1, vertexIndex, textureIndex, normalIndex)
        }

        let v  = vertexIndex * (slashCounter == 0 ? 10 : 1)  + (slashCounter == 0 ? Int(buffer[index] - c0) : 0)
        let vt = textureIndex * (slashCounter == 1 ? 10 : 1) + (slashCounter == 1 ? Int(buffer[index] - c0) : 0)
        let vn = normalIndex * (slashCounter == 2 ? 10 : 1)  + (slashCounter == 2 ? Int(buffer[index] - c0) : 0)
        return recursiveFace(&buffer, index + 1, slashCounter, v, vt, vn)
    }
}

// MARK: Parse group
fileprivate extension FwiOBJParser {

    fileprivate func validateGroup(_ buffer: inout [UInt8], _ index: Int) throws -> (Int, String?) {
        /* Condition validation: validate index out of bound */
        guard index + 1 < buffer.count else {
            return (incompleteBuffer, nil)
        }

        /* Condition validation: validate next byte(s) */
        if buffer[index + 1] != cSpace {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's group!"])
        }

        let beginLine = index + 2
        let length = recursiveGroup(&buffer, beginLine)
        return (length, String(bytesNoCopy: &buffer[beginLine], length: (length - beginLine), encoding: .utf8, freeWhenDone: false))
    }

    fileprivate func recursiveGroup(_ buffer: inout [UInt8], _ index: Int) -> Int {
        /* Condition validation: validate end of buffer */
        guard index < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cReturn else {
            return index
        }
        return recursiveGroup(&buffer, index + 1)
    }
}

// MARK: Parse material library
fileprivate extension FwiOBJParser {

    fileprivate func validateMaterialLibrary(_ buffer: inout [UInt8], _ index: Int) throws -> (Int, String?) {
        /* Condition validation: validate index out of bound */
        guard index + 6 < buffer.count else {
            return (incompleteBuffer, nil)
        }

        /* Condition validation: validate next byte(s) */
        if buffer[index + 1] != cT && buffer[index + 2] != cL && buffer[index + 3] != cL && buffer[index + 4] != cI && buffer[index + 5] != cB && buffer[index + 6] != cSpace {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's material library!"])
        }

        let beginLine = index + 7
        let length = recursiveMaterialLibrary(&buffer, beginLine)
        return (length, String(bytesNoCopy: &buffer[beginLine], length: (length - beginLine), encoding: .utf8, freeWhenDone: false))
    }

    fileprivate func recursiveMaterialLibrary(_ buffer: inout [UInt8], _ index: Int) -> Int {
        /* Condition validation: validate end of buffer */
        guard index < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cReturn else {
            return index
        }
        return recursiveMaterialLibrary(&buffer, index + 1)
    }
}

// MARK: Parse material name
fileprivate extension FwiOBJParser {

    fileprivate func validateMaterialName(_ buffer: inout [UInt8], _ index: Int) throws -> (Int, String?) {
        /* Condition validation: validate index out of bound */
        guard index + 6 < buffer.count else {
            return (incompleteBuffer, nil)
        }

        /* Condition validation: validate next byte(s) */
        if !(buffer[index + 1] == cS && buffer[index + 2] == cE && buffer[index + 3] == cM && buffer[index + 4] == cT && buffer[index + 5] == cL && buffer[index + 6] == cSpace) {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's material name!"])
        }

        let beginLine = index + 7
        let length = recursiveMaterialName(&buffer, beginLine)
        return (length, String(bytesNoCopy: &buffer[beginLine], length: (length - beginLine), encoding: .utf8, freeWhenDone: false))
    }

    fileprivate func recursiveMaterialName(_ buffer: inout [UInt8], _ index: Int) -> Int {
        /* Condition validation: validate end of buffer */
        guard index < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cReturn else {
            return index
        }
        return recursiveMaterialName(&buffer, index + 1)
    }
}

// MARK: Parse vertex
fileprivate extension FwiOBJParser {

    fileprivate func validateVertex(_ buffer: inout [UInt8], _ index: Int) throws -> Int {
        /* Condition validation: validate index out of bound */
        guard index + 2 < buffer.count else {
            return incompleteBuffer
        }

        /* Condition validation: validate next byte(s) */
        if buffer[index + 1] != cSpace && buffer[index + 1] != cN && buffer[index + 1] != cT {
            throw NSError(domain: "com.fiision.lib.OpenGLES", code: -1, userInfo: [NSLocalizedDescriptionKey:"Invalid obj's vertex! Only (v|vt|vn) is accepted."])
        }
        var length = incompleteBuffer

        if buffer[index + 1] == cSpace {
            let (l1, x) = recursiveGeometricVertex(&buffer, index + 2)
            let (l2, y) = recursiveGeometricVertex(&buffer, l1 + 1)
            let (l3, z) = recursiveGeometricVertex(&buffer, l2 + 1)
            length = l3

//            #if DEBUG_PARSER
//                let text1 = String(format: "v %6f %6f %6f", x, y, z)
//                let text2 = String(bytesNoCopy: &buffer[index], length: (length - index), encoding: .utf8, freeWhenDone: false)
//
//                if text1 != text2 && l1 != incompleteData && l2 != incompleteData && l3 != incompleteData {
//                    debugPrint("Expected \(String(describing: text2)) but found: \(text1)")
//                }
//            #endif
        } else if buffer[index + 1] == cT && buffer[index + 2] == cSpace {
            let (l1, x) = recursiveGeometricVertex(&buffer, index + 3)
            let (l2, y) = recursiveGeometricVertex(&buffer, l1 + 1)
            length = l2

//            #if DEBUG_PARSER
//                let text1 = String(format: "vt %6f %6f", x, y)
//                let text2 = String(bytesNoCopy: &buffer[index], length: (length - index), encoding: .utf8, freeWhenDone: false)
//
//                if text1 != text2 && l1 != incompleteData && l2 != incompleteData {
//                    debugPrint("Expected \(String(describing: text2)) but found: \(text1)")
//                }
//            #endif
        }
//        else if buffer[index + 1] == cN && buffer[index + 2] == cSpace {
//        }
        return length > 0 ? length : incompleteBuffer
    }

    fileprivate func recursiveGeometricVertex(_ buffer: inout [UInt8], _ index: Int, _ decimal: Double = 0) -> (Int, Double) {
        /* Condition validation: validate end of buffer */
        guard 0 < index && index < buffer.count else {
            return (incompleteData, 0)
        }
//        let pointer: UnsafePointer<UInt8>? = nil

        /* Condition validation: terminate recursion */
        guard buffer[index] != cSpace && buffer[index] != cReturn else {
            return (index, 0)
        }

        // Check decimal number
        var nextDecimal = decimal / 10.0
        if buffer[index] == cDot {
            nextDecimal = 0.1
        }

        /* Condition validation: validate invalid length */
        let (length, vertex) = recursiveGeometricVertex(&buffer, index + 1, nextDecimal)
        guard length != incompleteData else {
            return (incompleteData, 0)
        }

        if buffer[index] == cMinus {
            return (length, -vertex)
        } else if buffer[index] == cDot {
            return (length, vertex)
        } else {
            if decimal != 0 {
                return (length, (Double(buffer[index] - c0) * decimal + vertex))
            } else {
                return (length, (Double(buffer[index] - c0) + vertex))
            }
        }
    }

    fileprivate func recursiveTextureVertex(_ buffer: inout [UInt8], _ index: Int, _ decimal: Double = 0) -> (Int, Double) {
        /* Condition validation: validate end of buffer */
        guard 0 < index && index < buffer.count else {
            return (incompleteData, 0)
        }

        /* Condition validation: terminate recursion */
        guard buffer[index] != cSpace && buffer[index] != cReturn else {
            return (index, 0)
        }

        // Check decimal number
        var nextDecimal = decimal / 10.0
        if buffer[index] == cDot {
            nextDecimal = 0.1
        }

        /* Condition validation: validate invalid length */
        let (length, vertex) = recursiveTextureVertex(&buffer, index + 1, nextDecimal)
        guard length != incompleteData else {
            return (incompleteData, 0)
        }

        if buffer[index] == cMinus {
            return (length, -vertex)
        } else if buffer[index] == cDot {
            return (length, vertex)
        } else {
            if decimal != 0 {
                return (length, (Double(buffer[index] - c0) * decimal + vertex))
            } else {
                return (length, (Double(buffer[index] - c0) + vertex))
            }
        }
    }
//    Vertex normals
}

// MARK: Class's private methods
fileprivate extension FwiOBJParser {

    /// Move remaining bytes to beginning of buffer before reading next.
    /// 
    /// @param
    /// - buffer {[UInt8]} (a buffer)
    /// - fromIndex {Int} (an origin)
    /// - toIndex {Int} (a destination)
    /// - threshold {Int} (break point)
    fileprivate func moveRemainBytes(_ buffer: inout [UInt8], _ fromIndex: Int, _ toIndex: Int, _ threshold: Int) {
        guard fromIndex < threshold else {
            return
        }
        buffer[toIndex] = buffer[fromIndex]
        moveRemainBytes(&buffer, fromIndex + 1, toIndex + 1, threshold)
    }
}
