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
    
    func testFindNewlyPlacedBricks() {
        let testMap = makeBricks()
        
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
    
    func testCalculateWordScore() {
        let board = makeBoard()
        
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
