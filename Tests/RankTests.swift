//
//  RankTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class RankTests: XCTestCase {
    
    typealias Bricks = Matrix<PlacedBrick?>
//    typealias Board = Matrix<BoardPosition>
    
    func testNewly() {
        let testMap = self.testMap()
        
        assert(Rank.findNewlyPlacedBricks(
            makeWord("catzs"),
            direction: .horizontal,
            position: .init(row: 1, column: 2),
            bricks: testMap
            ) == controlWord(characters: "zs", starting: 3))
        
        assert(Rank.findNewlyPlacedBricks(
            makeWord("fat"),
            direction: .vertical,
            position: .init(row: 0, column: 3),
            bricks: testMap
            ) == [FixedBrick(brick: .character("f"), index: 0), FixedBrick(brick: .character("t"), index: 2)])
    }
    
    func testBerp() {
        let board = makeBoard()
        board.dump()
        
        let letterBonus: [Rank.RankingBrick] = [
            .init(brick: PlacedBrick.character("c"), position: .init(row: 0, column: 0), isNewlyPlaced: true),
            .init(brick: PlacedBrick.character("a"), position: .init(row: 0, column: 1), isNewlyPlaced: false),
            .init(brick: PlacedBrick.character("t"), position: .init(row: 0, column: 2), isNewlyPlaced: false),
        ]
        assert(Rank.calculateScore(for: letterBonus, board: board) == 27)
        
        let wordBonus: [Rank.RankingBrick] = [
            .init(brick: PlacedBrick.character("c"), position: .init(row: 4, column: 0), isNewlyPlaced: true),
            .init(brick: PlacedBrick.character("a"), position: .init(row: 4, column: 1), isNewlyPlaced: false),
            .init(brick: PlacedBrick.character("t"), position: .init(row: 4, column: 2), isNewlyPlaced: false),
        ]
        assert(Rank.calculateScore(for: wordBonus, board: board) == 33)
        
        let ignoringNotNewlyPlaces: [Rank.RankingBrick] = [
            .init(brick: PlacedBrick.character("c"), position: .init(row: 4, column: 2), isNewlyPlaced: true),
            .init(brick: PlacedBrick.character("a"), position: .init(row: 4, column: 3), isNewlyPlaced: false),
            .init(brick: PlacedBrick.character("t"), position: .init(row: 4, column: 4), isNewlyPlaced: false),
        ]
        assert(Rank.calculateScore(for: ignoringNotNewlyPlaces, board: board) == 11)
        
        let jokerWord: [Rank.RankingBrick] = [
            .init(brick: PlacedBrick.joker("c"), position: .init(row: 4, column: 0), isNewlyPlaced: true),
            .init(brick: PlacedBrick.character("a"), position: .init(row: 4, column: 1), isNewlyPlaced: false),
            .init(brick: PlacedBrick.character("t"), position: .init(row: 4, column: 2), isNewlyPlaced: false),
        ]
        assert(Rank.calculateScore(for: jokerWord, board: board) == 9)
    }

}


extension RankTests {
    
    func makeList() -> List {
        List(["hus","fat","fatty","cat","zap","catz","pm"])
    }
    
    func makeWord(_ word: String) -> [PlacedBrick] {
        word.map(PlacedBrick.character)
    }
    
    func makeBoard() -> Matrix<BoardPosition> {
        Matrix(Board.standart)
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
    
    func printResult(_ result: Validate.ValidatedResult) {
        print("Word: ", String(result.word.map { $0.character }))
        result.crossWords.forEach(printCrossWord)
    }
    
}
