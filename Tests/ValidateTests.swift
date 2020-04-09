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
    
    func testCrossWords() {
        let testMap = self.testMap()
        testMap[MatrixIndex.init(row: 0, column: 3)] = .character("f")
        testMap[MatrixIndex.init(row: 2, column: 3)] = .character("t")
        
        testMap[MatrixIndex.init(row: 3, column: 4)] = .character("m")
        testMap[MatrixIndex.init(row: 3, column: 5)] = .character("o")
        testMap[MatrixIndex.init(row: 3, column: 7)] = .character("s")
        testMap[MatrixIndex.init(row: 5, column: 4)] = .character("d")
        testMap[MatrixIndex.init(row: 5, column: 5)] = .character("e")
        testMap[MatrixIndex.init(row: 5, column: 7)] = .character("p")
        testMap[MatrixIndex.init(row: 8, column: 7)] = .character("o")
        testMap[MatrixIndex.init(row: 8, column: 8)] = .character("p")
        testMap.dump()
        
        let catResult = Validate.findCrossWords(
            cat(),
            wordDirection: .horizontal,
            position: .init(row: 1, column: 2),
            bricks: testMap
        )
        let fatControl = Validate.CrossWord.init(crossingIndex: 1, word: controlWord(characters: "fat", starting: -1))
        assert(catResult.crossWords == [fatControl])
        assert(catResult.originalWord == cat())
        
        let martinResult = Validate.findCrossWords(
            martin(),
            wordDirection: .vertical,
            position: .init(row: 3, column: 6),
            bricks: testMap
        )
        let momsControl = Validate.CrossWord.init(crossingIndex: 0, word: controlWord(characters: "moms", starting: -2))
        let derpControl = Validate.CrossWord.init(crossingIndex: 2, word: controlWord(characters: "derp", starting: -2))
        let nopControl = Validate.CrossWord.init(crossingIndex: 5, word: controlWord(characters: "nop", starting: 0))
        assert(martinResult.crossWords == [momsControl, derpControl, nopControl])
        assert(martinResult.originalWord == martin())
    }

}

extension ValidateTests {
    
    func testList() -> [String] {
        ["hus","mus","bjørn","basse"]
    }
    
    func hus() -> [PlacedBrick] {
        "hus".map(PlacedBrick.character)
    }
    
    func lol() -> [PlacedBrick] {
        "lol".map(PlacedBrick.character)
    }
    
    func cat() -> [PlacedBrick] {
        "cat".map(PlacedBrick.character)
    }
    
    func martin() -> [PlacedBrick] {
        "martin".map(PlacedBrick.character)
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
    
    func printCrossWord(_ crossWord: Validate.CrossWord) {
        let word = String(crossWord.word.map { $0.brick.character })
        let startingAt = crossWord.word.first?.index
        print("crossing: ", crossWord.crossingIndex, " starting at: ", startingAt ?? "X", " word: ", word)
    }
    
}
