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
    
    func testIsWithinBoard() {
        assert(MatrixIndex.init(row: 0, column: 0).isWithinBoard())
        assert(MatrixIndex.init(row: 1, column: 1).isWithinBoard())
        assert(!MatrixIndex.init(row: Board.size, column: 0).isWithinBoard())
        assert(!MatrixIndex.init(row: 0, column: Board.size).isWithinBoard())
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
        
        // Testing `moveLine`
        assert(MatrixIndex(row: 3, column: 3).moveLine(.vertical, 1, to: .begin)
            == .init(row: 4, column: 0))
        assert(MatrixIndex(row: 3, column: 3).moveLine(.vertical, 1, to: .end)
            == .init(row: 4, column: 14))
        assert(MatrixIndex(row: 3, column: 3).moveLine(.horizontal, 1, to: .begin)
            == .init(row: 0, column: 4))
        assert(MatrixIndex(row: 3, column: 3).moveLine(.horizontal, 1, to: .end)
            == .init(row: 14, column: 4))
        
        // Testing `iterate`
        assert(MatrixIndex.init(row: 0, column: 0).iterate(.forward, .horizontal) == .init(row: 0, column: 1))
        assert(MatrixIndex.init(row: 0, column: 0).iterate(.forward, .vertical) == .init(row: 1, column: 0))
        assert(MatrixIndex.init(row: 0, column: 0).iterate(.backward, .horizontal) == nil)
        assert(MatrixIndex.init(row: 0, column: 0).iterate(.backward, .vertical) == nil)
        
        assert(MatrixIndex.init(row: 5, column: 5).iterate(.forward, .horizontal) == .init(row: 5, column: 6))
        assert(MatrixIndex.init(row: 5, column: 5).iterate(.forward, .vertical) == .init(row: 6, column: 5))
        assert(MatrixIndex.init(row: 5, column: 5).iterate(.backward, .horizontal) == .init(row: 5, column: 4))
        assert(MatrixIndex.init(row: 5, column: 5).iterate(.backward, .vertical) == .init(row: 4, column: 5))
        
        assert(MatrixIndex.init(row: 14, column: 5).iterate(.forward, .horizontal) == .init(row: 14, column: 6))
        assert(MatrixIndex.init(row: 14, column: 5).iterate(.forward, .vertical) == .init(row: 0, column: 6))
        assert(MatrixIndex.init(row: 14, column: 5).iterate(.backward, .horizontal) == .init(row: 14, column: 4))
        assert(MatrixIndex.init(row: 14, column: 5).iterate(.backward, .vertical) == .init(row: 13, column: 5))
        
        assert(MatrixIndex.init(row: 14, column: 14).iterate(.forward, .horizontal) == nil)
        assert(MatrixIndex.init(row: 14, column: 14).iterate(.forward, .vertical) == nil)
        assert(MatrixIndex.init(row: 14, column: 14).iterate(.backward, .horizontal) == .init(row: 14, column: 13))
        assert(MatrixIndex.init(row: 14, column: 14).iterate(.backward, .vertical) == .init(row: 13, column: 14))
    }
}
