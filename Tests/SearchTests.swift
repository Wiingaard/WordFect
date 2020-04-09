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
    
    typealias Bricks = Matrix<PlacedBrick?>
    
    // [a, 1, 2, b, 3, 4, c, d, _, e]
    // Expecting: "a1234bc"
    func testAdjustMatch() {
        let word: [PlacedBrick] = [
            PlacedBrick.character("1"),
            PlacedBrick.character("2"),
            PlacedBrick.character("3"),
            PlacedBrick.character("4")
        ]
        
        let fixed: [FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let adjustedWord = Search.adjust(string: word, fixed: fixed)
        
        let checkWord = String(adjustedWord.map { $0.character })
        
        assert(checkWord == "a12b34cd")
    }
    
    func testPotentialMatchesWithJoker() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.joker
        ]
        
        let fixed: [FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let matches = Search.potentialMatches(
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
        
        let fixed: [FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 3),
            .init(brick: .character("c"), index: 6),
            .init(brick: .character("d"), index: 7),
            .init(brick: .character("e"), index: 9)
        ]
        
        let matches = Search.potentialMatches(
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
        let fixed: [FixedBrick] = [
            .init(brick: .character("a"), index: 0),
            .init(brick: .character("b"), index: 2),
            .init(brick: .character("b"), index: 5),
        ]
        
        assert(Search.canReachLength(1, permutationSetSize: 2, fixed: fixed) == true)
        assert(Search.canReachLength(2, permutationSetSize: 2, fixed: fixed) == true)
        assert(Search.canReachLength(3, permutationSetSize: 2, fixed: fixed) == true)
        assert(Search.canReachLength(4, permutationSetSize: 2, fixed: fixed) == true)
        assert(Search.canReachLength(5, permutationSetSize: 2, fixed: fixed) == false)
        assert(Search.canReachLength(5, permutationSetSize: 3, fixed: fixed) == true)
        assert(Search.canReachLength(6, permutationSetSize: 3, fixed: fixed) == true)
        
    }
    
    func testPotentialMatchesMinLength() {
        
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.character("2"),
            TrayBrick.character("3")
        ]
        
        let fixed: [FixedBrick] = [
            .init(brick: .character("a"), index: 1),
        ]
        
        let matches = Search.potentialMatches(
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
        let testMap = self.testMap()
        
        let martinLine = Search.getSearchLine(
            .vertical,
            position: MatrixIndex.init(row: 5, column: 6),
            bricks: testMap
        )
        let martinCharacters = martinLine.bricks.reduce("") { $0 + String($1.brick.character) }
        let martinIndexes = martinLine.bricks.map { $0.index }
        assert(martinLine.length == 10)
        assert(martinCharacters == "rtin")
        assert(martinIndexes == [0,1,2,3])
        
        let catLine = Search.getSearchLine(
            .horizontal,
            position: MatrixIndex.init(row: 1, column: 0),
            bricks: testMap
        )
        let catCharacters = catLine.bricks.reduce("") { $0 + String($1.brick.character) }
        let carIndexes = catLine.bricks.map { $0.index }
        assert(catLine.length == 15)
        assert(catCharacters == "cat")
        assert(carIndexes == [2,3,4])
    }
    
    func testLengthToNextBrick() {
        assert(Search.lengthToNextBrick(on: TestLine.cat, from: 0) == 2)
        assert(Search.lengthToNextBrick(on: TestLine.cat, from: 1) == 1)
        assert(Search.lengthToNextBrick(on: TestLine.cat, from: 2) == 1)
        assert(Search.lengthToNextBrick(on: TestLine.cat, from: 5) == nil)
    }
    
    func testFindMinimumSearchLength() {
        let testMap = self.testMap()
        assert(Search.findMinimumSearchLength(from: .init(row: 0, column: 1), direction: .horizontal, bricks: testMap) == 2)
        assert(Search.findMinimumSearchLength(from: .init(row: 1, column: 0), direction: .horizontal, bricks: testMap) == 2)
        assert(Search.findMinimumSearchLength(from: .init(row: 2, column: 0), direction: .horizontal, bricks: testMap) == 3)
        assert(Search.findMinimumSearchLength(from: .init(row: 3, column: 0), direction: .horizontal, bricks: testMap) == 6)
        assert(Search.findMinimumSearchLength(from: .init(row: 3, column: 6), direction: .horizontal, bricks: testMap) == 1)
        assert(Search.findMinimumSearchLength(from: .init(row: 3, column: 7), direction: .horizontal, bricks: testMap) == nil)
        assert(Search.findMinimumSearchLength(from: .init(row: 0, column: 1), direction: .vertical, bricks: testMap) == 2)
        assert(Search.findMinimumSearchLength(from: .init(row: 0, column: 2), direction: .vertical, bricks: testMap) == 1)
        assert(Search.findMinimumSearchLength(from: .init(row: 0, column: 6), direction: .vertical, bricks: testMap) == 3)
        assert(Search.findMinimumSearchLength(from: .init(row: 1, column: 6), direction: .vertical, bricks: testMap) == 2)
        assert(Search.findMinimumSearchLength(from: .init(row: 10, column: 10), direction: .vertical, bricks: testMap) == nil)
        assert(Search.findMinimumSearchLength(from: .init(row: 10, column: 10), direction: .horizontal, bricks: testMap) == nil)
    }

    func testSearch() {
        let tray: [TrayBrick] = [
            TrayBrick.character("1"),
            TrayBrick.character("2"),
            TrayBrick.character("3")
        ]
        
        let testMap = self.testMap()
        
        let search1 = Search.searchPosition(.init(row: 0, column: 0), bricks: testMap, tray: tray)
        assert(search1.horizontal.results.count == 6)
        assert(search1.vertical.results.count == 0)
        
        let search2 = Search.searchPosition(.init(row: 0, column: 2), bricks: testMap, tray: tray)
        assert(search2.horizontal.results.count == 12)
        assert(search2.vertical.results.count == 15)
        
        let search3 = Search.searchPosition(.init(row: 5, column: 0), bricks: testMap, tray: tray)
        assert(search3.horizontal.results.count == 0)
        assert(search3.vertical.results.count == 0)
        
        let search4 = Search.searchPosition(.init(row: 2, column: 4), bricks: testMap, tray: tray)
        assert(search4.horizontal.results.count == 6)
        assert(search4.vertical.results.count == 0)
        
        let search5 = Search.searchPosition(.init(row: 1, column: 4), bricks: testMap, tray: tray)
        assert(search5.horizontal.results.count == 0)
        assert(search5.vertical.results.count == 15)
        
        let search6 = Search.searchPosition(.init(row: 1, column: 2), bricks: testMap, tray: tray)
        assert(search6.horizontal.results.count == 15)
        assert(search6.vertical.results.count == 15)
    }
    
}

// MARK: - Helper

extension SearchTests {
    
    func printMatches(_ matches: Set<[PlacedBrick]>) {
        print(matches
            .map { match in match.reduce("") { $0 + String($1.character) } }
            .sorted()
            .joined(separator: "\n")
        )
    }
    
    func printSearchResults(_ results: Search.DirectionSearch) {
        print(results.results.count, " results for ", results.direction)
        printMatches(results.results)
    }
    
    func testMap() -> Search.Bricks {
        let map = Bricks(TestMap.empty)
        map[.horizontal, 1] = TestLine.cat
        map[.vertical, 6] = TestLine.martin
        return map
    }
}
