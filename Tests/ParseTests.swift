//
//  ParseTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 21/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class ParseTests: XCTestCase {
    
    func testValidLine() {
        let isValid = ParseWordList.isValidWord
        
        assert(isValid("abc"))
        assert(isValid("æøå"))
        assert(!isValid("abc."))
        assert(!isValid("ab c"))
        assert(!isValid("abc1"))
        assert(!isValid("Abc"))
    }
    
}
