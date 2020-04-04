//
//  MatrixTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 04/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class MatrixTests: XCTestCase {

    func testMatrixSubscript() {
        let testMatrix = Matrix<PlacedBrick?>.init(TestMap.empty)
        
        testMatrix[.horizontal, 1] = TestLine.cat
        assert(testMatrix[.horizontal, 1] == TestLine.cat)
        
        testMatrix[.vertical, 6] = TestLine.martin
        assert(testMatrix[.vertical, 6] == TestLine.martin)
        
        testMatrix[.init(row: 3, column: 3)] = PlacedBrick.joker("x")
        assert(testMatrix[.init(row: 3, column: 3)] == PlacedBrick.joker("x"))
    }
    
    func testMatrixDirection() {
        let vertical = MatrixDirection.vertical
        assert(vertical.orthogonal == .horizontal)
        assert(vertical.orthogonal.orthogonal == .vertical)
    }
    
    func testMatrixIndex() {
        // Testing `move`
        let testIndex = MatrixIndex.init(row: 0, column: 3)
        assert(testIndex.move(.horizontal, count: -1) == MatrixIndex.init(row: 0, column: 2))
        assert(testIndex.move(.horizontal, count: 1) == MatrixIndex.init(row: 0, column: 4))
        assert(testIndex.move(.vertical, count: -1) == MatrixIndex.init(row: -1, column: 3))
        assert(testIndex.move(.vertical, count: 1) == MatrixIndex.init(row: 1, column: 3))
        
        // Testing `subscript`
        let movedIndexHorizontal = testIndex.move(.horizontal, count: 5)
        assert(movedIndexHorizontal[.horizontal] == 8)
        let movedIndexVertical = testIndex.move(.vertical, count: 5)
        assert(movedIndexVertical[.vertical] == 5)
    }
}
