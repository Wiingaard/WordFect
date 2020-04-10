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
        assert(list.contains(makeWord("hus")))
        assert(!list.contains(makeWord("nothus")))
        assert(list.contains(makeFixed("hus")))
        assert(!list.contains(makeFixed("nothus")))
    }
}
