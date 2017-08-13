import XCTest
@testable import FwiOpenGLES


class FwiOpenGLES2Tests: XCTestCase {
    func testExample() {
//        let chars = "v vt vn plf g usemtl mtllib / .0123456789 # \n-".characters
//        let set = Set<Character>(chars).sorted()
//        set.forEach { (char) in
//            debugPrint("let \(char) = \(String(char).utf8.first!) // '\(char)'")
//        }

        

//        let cV: UInt8 = 118 // 'v'
//        let c: Character = "v"
//
//        let text1 = "vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv".utf8.map { UInt8($0) }
//        let begin1 = Date()
//        for _ in (0..<1000) {
//
//            for value in text1 {
//                let flag = value == cV
////                debugPrint(value == cV)
//            }
//        }
//        let end1 = Date()
//
//
//        let begin2 = Date()
//        for _ in (0..<1000) {
//            let text2 = String(bytes: text1, encoding: .ascii)!.characters
//            for char in text2 {
//                let flag = char == c
////                debugPrint(char == c)
//            }
//        }
//        let end2 = Date()
//
//        debugPrint(end1.timeIntervalSince(begin1))
//        debugPrint(end2.timeIntervalSince(begin2))


        let path = Bundle(for: FwiOpenGLES2Tests.self).path(forResource: "BlondeElexis", ofType: "obj")
        var parser = try? FwiOBJParser(path: path)

        let begin = Date()
        try? parser?.parse()
        let end = Date()
        debugPrint(end.timeIntervalSince(begin))
    }

    func testBenchmark() {
        let path = Bundle(for: FwiOpenGLES2Tests.self).path(forResource: "BlondeElexis", ofType: "obj")
        var parser = try? FwiOBJParser(path: path)

        measure {
            try? parser?.parse()
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
