//
//  ValidateTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class ValidateTests: XCTestCase {
    
    func testIsValidWord() {
        assert(Validate.isValidWord(hus(), list: testList()) == true)
        assert(Validate.isValidWord(lol(), list: testList()) == false)
    }

}

extension ValidateTests {
    
    func testList() -> [String] {
        ["hus","mus","bjørn","basse"]
    }
    
    func hus() -> [PlacedBrick] {
        [.character("h"), .character("u"), .joker("s")]
    }
    
    func lol() -> [PlacedBrick] {
        [.character("l"), .character("l"), .joker("l")]
    }
    
}
