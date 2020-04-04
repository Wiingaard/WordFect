//
//  SearchTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 29/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class SearchTests: XCTestCase {
    
    // [a, 1, 2, b, 3, 4, c, d, _, e]
    // Expecting: "a1234bc"
    func testAdjustMatch() {
        var word: [PlacedBrick] = [
            PlacedBrick.character("1"),
            PlacedBrick.character("2"),
            PlacedBrick.character("3"),
            PlacedBrick.character("4")
        ]
        
        let fixed: [PlayingField.FixedCharecter] = [
            (character: "a", index: 0),
            (character: "b", index: 3),
            (character: "c", index: 6),
            (character: "d", index: 7),
            (character: "e", index: 9),
        ]
        
        PlayingField.adjust(string: &word, fixed: fixed)
        
        let checkWord = String(word.map { $0.character })
        
        assert(checkWord == "a12b34cd")
    }
    
    func testPotentialMatchesWithJoker() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.joker
        ]
        
        let fixed: [PlayingField.FixedCharecter] = [
            (character: "a", index: 0),
            (character: "b", index: 3),
            (character: "c", index: 6),
            (character: "d", index: 7),
            (character: "e", index: 9),
        ]
        
        let matches = PlayingField.potentialMatches(
            tray: tray,
            fixed: fixed,
            lineLength: 6
        )
        
        func matchesOfLength(_ length: Int) -> Int {
            return matches.filter { $0.count == length }.count
        }
        
        assert(matchesOfLength(0) == 0)
        assert(matchesOfLength(1) == 0)
        assert(matchesOfLength(2) == 29)
        assert(matchesOfLength(3) == 0)
        assert(matchesOfLength(4) == 56)
        assert(matchesOfLength(5) == 0)
        assert(matchesOfLength(6) == 0)
        assert(matchesOfLength(7) == 0)
    }
    
    func testPotentialMatches() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.character("2"),
            TrayBrick.character("3"),
            TrayBrick.character("4"),
            TrayBrick.character("5"),
            TrayBrick.character("6"),
            TrayBrick.character("7")
        ]
        
        let fixed: [PlayingField.FixedCharecter] = [
            (character: "a", index: 0),
            (character: "b", index: 3),
            (character: "c", index: 6),
            (character: "d", index: 7),
            (character: "e", index: 9),
        ]
        
        let matches = PlayingField.potentialMatches(
            tray: tray,
            fixed: fixed,
            lineLength: 15
        )
        
        func matchesOfLength(_ length: Int) -> Int {
            return matches.filter { $0.count == length }.count
        }
        
        assert(matchesOfLength(2) == 7)
        assert(matchesOfLength(4) == 42)
        assert(matchesOfLength(5) == 210)
        assert(matchesOfLength(8) == 840)
        assert(matchesOfLength(10) == 2520)
        assert(matchesOfLength(11) == 5040)
        assert(matchesOfLength(12) == 5040)
    }
    
    func testGetSearchLine() {
        
        let playingField = PlayingField(bricks: TestMap.empty)
        playingField.bricks[.horizontal, 1] = TestLine.cat
        playingField.bricks[.vertical, 6] = TestLine.martin
        
        let martinLine = playingField.getSearchLine(.vertical, position: MatrixIndex.init(row: 5, column: 6))
        let martinCharacters = martinLine.fixedCharacter.reduce("") { $0 + String($1.brick.character) }
        let martinIndexes = martinLine.fixedCharacter.map { $0.index }
        
        assert(martinLine.length == 10)
        assert(martinCharacters == "rtin")
        assert(martinIndexes == [0,1,2,3])
        
        let catLine = playingField.getSearchLine(.horizontal, position: MatrixIndex.init(row: 1, column: 0))
        let catCharacters = catLine.fixedCharacter.reduce("") { $0 + String($1.brick.character) }
        let carIndexes = catLine.fixedCharacter.map { $0.index }
        
        assert(catLine.length == 15)
        assert(catCharacters == "cat")
        assert(carIndexes == [2,3,4])
        
    }

}
