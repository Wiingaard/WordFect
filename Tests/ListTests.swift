//
//  ListTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class ListTests: XCTestCase {

    func testList() {
        let list = List(["hus","mojn"])
        
        assert(list.contains("hus"))
        assert(!list.contains("nothus"))
        assert(list.contains(makePlaced("hus")))
        assert(!list.contains(makePlaced("nothus")))
        assert(list.contains(makeFixed("hus")))
        assert(!list.contains(makeFixed("nothus")))
    }
    
    func makePlaced(_ word: String) -> [PlacedBrick] {
        word.map(PlacedBrick.character)
    }
    
    func makeFixed(_ word: String) -> [FixedBrick] {
        word.enumerated().map { FixedBrick(brick: PlacedBrick.character($1), index: $0) }
    }
    
}
