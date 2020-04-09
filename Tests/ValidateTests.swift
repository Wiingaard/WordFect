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
    
    typealias Bricks = Matrix<PlacedBrick?>
    
    func testIsValidWord() {
        assert(Validate.isValidWord(hus(), list: testList()) == true)
        assert(Validate.isValidWord(lol(), list: testList()) == false)
    }
    
    func testFindWord() {
        let testMap = self.testMap()
        testMap[MatrixIndex.init(row: 1, column: 6)] = .character("h")
        testMap[MatrixIndex.init(row: 4, column: 3)] = .character("o")
        
        testMap[MatrixIndex.init(row: 0, column: 12)] = .character("1")
        testMap[MatrixIndex.init(row: 0, column: 13)] = .character("2")
        testMap[MatrixIndex.init(row: 0, column: 14)] = .character("3")
        testMap.dump()
        
        assert(Validate.findWord(
            .init(row: 1, column: 3),
            direction: .horizontal,
            bricks: testMap
            ) == controlWord(characters: "cat", starting: -1) )
        
        assert(Validate.findWord(
            .init(row: 1, column: 3),
            direction: .vertical,
            bricks: testMap
            ) == controlWord(characters: "a", starting: 0) )
        
        assert(Validate.findWord(
            .init(row: 7, column: 6),
            direction: .vertical,
            bricks: testMap
            ) == controlWord(characters: "martin", starting: -4) )
        
        assert(Validate.findWord(
            .init(row: 0, column: 11),
            direction: .horizontal,
            bricks: testMap
            ) == [] )
        
        assert(Validate.findWord(
            .init(row: 0, column: 12),
            direction: .horizontal,
            bricks: testMap
            ) == controlWord(characters: "123", starting: 0) )
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
    
    func testMap() -> Search.Bricks {
        let map = Bricks(TestMap.empty)
        map[.horizontal, 1] = TestLine.cat
        map[.vertical, 6] = TestLine.martin
        return map
    }
    
    func controlWord(characters: String, starting: Int) -> [FixedBrick] {
        var result = [FixedBrick]()
        var index = starting
        characters.forEach { char in
            result.append(.init(brick: .character(char), index: index))
            index += 1
        }
        return result
    }
    
}
