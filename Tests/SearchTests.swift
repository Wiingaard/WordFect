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
        let word: [PlacedBrick] = [
            PlacedBrick.character("1"),
            PlacedBrick.character("2"),
            PlacedBrick.character("3"),
            PlacedBrick.character("4")
        ]
        
        let fixed: [PlayingField.FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let adjustedWord = PlayingField.adjust(string: word, fixed: fixed)
        
        let checkWord = String(adjustedWord.map { $0.character })
        
        assert(checkWord == "a12b34cd")
    }
    
    func testPotentialMatchesWithJoker() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.joker
        ]
        
        let fixed: [PlayingField.FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let matches = PlayingField.potentialMatches(
            tray: tray,
            fixed: fixed,
            maxLength: 6,
            minLength: 1
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
        
        let fixed: [PlayingField.FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let matches = PlayingField.potentialMatches(
            tray: tray,
            fixed: fixed,
            maxLength: 15,
            minLength: 1
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
    
    func testCanReactLength() {
        let fixed: [PlayingField.FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 2),
            .init(brick: .character("b"), index: 5),
        ]
        
        assert(PlayingField.canReachLength(1, permutationSetSize: 2, fixed: fixed) == true)
        assert(PlayingField.canReachLength(2, permutationSetSize: 2, fixed: fixed) == true)
        assert(PlayingField.canReachLength(3, permutationSetSize: 2, fixed: fixed) == true)
        assert(PlayingField.canReachLength(4, permutationSetSize: 2, fixed: fixed) == true)
        assert(PlayingField.canReachLength(5, permutationSetSize: 2, fixed: fixed) == false)
        assert(PlayingField.canReachLength(5, permutationSetSize: 3, fixed: fixed) == true)
        assert(PlayingField.canReachLength(6, permutationSetSize: 3, fixed: fixed) == true)
        
    }
    
    func printMatches(_ matches: Set<[PlacedBrick]>) {
        print(matches
            .map { match in match.reduce("") { $0 + String($1.character) } }
            .sorted()
            .joined(separator: "\n")
        )
    }
    
    func printSearchResults(_ results: PlayingField.DirectionSearch) {
        print(results.results.count, " results for ", results.direction)
        printMatches(results.results)
    }
    
    func testPotentialMatchesMinLength() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.character("2"),
            TrayBrick.character("3")
        ]
        
        let fixed: [PlayingField.FixedBrick] = [
            .init(brick: .character("a"), index: 1),
        ]
        
        let matches = PlayingField.potentialMatches(
            tray: tray,
            fixed: fixed,
            maxLength: 15,
            minLength: 4
        )
        
        func matchesOfLength(_ length: Int) -> Int {
            return matches.filter { $0.count == length }.count
        }
        
        assert(matchesOfLength(1) == 0)
        assert(matchesOfLength(2) == 0)
        assert(matchesOfLength(3) == 0)
        assert(matchesOfLength(4) == 6)
        assert(matchesOfLength(5) == 0)
        assert(matchesOfLength(6) == 0)
        assert(matchesOfLength(7) == 0)
    }
    
    func testGetSearchLine() {
        
        let playingField = PlayingField(bricks: TestMap.empty)
        playingField.bricks[.horizontal, 1] = TestLine.cat
        playingField.bricks[.vertical, 6] = TestLine.martin
        
        let martinLine = playingField.getSearchLine(.vertical, position: MatrixIndex.init(row: 5, column: 6))
        let martinCharacters = martinLine.bricks.reduce("") { $0 + String($1.brick.character) }
        let martinIndexes = martinLine.bricks.map { $0.index }
        
        assert(martinLine.length == 10)
        assert(martinCharacters == "rtin")
        assert(martinIndexes == [0,1,2,3])
        
        let catLine = playingField.getSearchLine(.horizontal, position: MatrixIndex.init(row: 1, column: 0))
        let catCharacters = catLine.bricks.reduce("") { $0 + String($1.brick.character) }
        let carIndexes = catLine.bricks.map { $0.index }
        
        assert(catLine.length == 15)
        assert(catCharacters == "cat")
        assert(carIndexes == [2,3,4])
        
    }
    
    func testPositionSearch() {
        let playingField = PlayingField(bricks: TestMap.empty)
        playingField.bricks[.horizontal, 1] = TestLine.cat
        playingField.bricks[.vertical, 6] = TestLine.martin
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.character("2"),
            TrayBrick.character("3")
        ]
        
        let firstSearch = playingField.searchPosition(.init(row: 0, column: 0), tray: tray)
        
        printSearchResults(firstSearch.horizontal)
    }

}
