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
    
    /// When adding a word (zap) to connect between two words (cat and martin), both original word and two cross words are found
    func testFindWordsToRank() {
        let testMap = makeBricks()
        
        let catzCrossWord = Validate.CrossWord.init(crossingIndex: 0, word: [
            .init(brick: PlacedBrick.character("c"), index: -3),
            .init(brick: PlacedBrick.character("a"), index: -2),
            .init(brick: PlacedBrick.character("t"), index: -1),
            .init(brick: PlacedBrick.character("z"), index: 0),
        ])
        
        let pmCrossWord = Validate.CrossWord.init(crossingIndex: 2, word: [
            .init(brick: PlacedBrick.character("p"), index: 0),
            .init(brick: PlacedBrick.character("m"), index: 1)
        ])
        
        let rankingWords = Rank.findWordsToRank(
            makeWord("zap"),
            crossWords: [catzCrossWord, pmCrossWord],
            direction: .vertical,
            position: .init(row: 1, column: 5),
            bricks: testMap
        )
        
        let zapRankingControl: [Rank.RankingBrick] = [
            .init(brick: .character("z"), position: .init(row: 1, column: 5), isNewlyPlaced: true),
            .init(brick: .character("a"), position: .init(row: 2, column: 5), isNewlyPlaced: true),
            .init(brick: .character("p"), position: .init(row: 3, column: 5), isNewlyPlaced: true)
        ]
        
        let catzRankingControl: [Rank.RankingBrick] = [
            .init(brick: .character("c"), position: .init(row: 1, column: 2), isNewlyPlaced: false),
            .init(brick: .character("a"), position: .init(row: 1, column: 3), isNewlyPlaced: false),
            .init(brick: .character("t"), position: .init(row: 1, column: 4), isNewlyPlaced: false),
            .init(brick: .character("z"), position: .init(row: 1, column: 5), isNewlyPlaced: true)
        ]
        
        let pmRankingControl: [Rank.RankingBrick] = [
            .init(brick: .character("p"), position: .init(row: 3, column: 5), isNewlyPlaced: true),
            .init(brick: .character("m"), position: .init(row: 3, column: 6), isNewlyPlaced: false)
        ]
        
        assert(rankingWords.wordsToRank.count == 3)
        assert(rankingWords.wordsToRank.contains(zapRankingControl))
        assert(rankingWords.wordsToRank.contains(catzRankingControl))
        assert(rankingWords.wordsToRank.contains(pmRankingControl))
    }
    
    /// Adding a 's' to 'martin', filtering out old crosswords in the middel
    func testFindWordsToRank2() {
        let testMap = makeBricks()
        testMap[MatrixIndex.init(row: 4, column: 5)] = .character("x")
        testMap[MatrixIndex.init(row: 4, column: 7)] = .character("x")
        
        let xaxCrossWord = Validate.CrossWord.init(crossingIndex: 0, word: [
            .init(brick: PlacedBrick.character("x"), index: -3),
            .init(brick: PlacedBrick.character("a"), index: -2),
            .init(brick: PlacedBrick.character("x"), index: -1)
        ])
        
        let rankingWords = Rank.findWordsToRank(
            makeWord("martins"),
            crossWords: [xaxCrossWord],
            direction: .vertical,
            position: .init(row: 3, column: 6),
            bricks: testMap
        )
        
        let martinsRankingControl: [Rank.RankingBrick] = [
            .init(brick: .character("m"), position: .init(row: 3, column: 6), isNewlyPlaced: false),
            .init(brick: .character("a"), position: .init(row: 4, column: 6), isNewlyPlaced: false),
            .init(brick: .character("r"), position: .init(row: 5, column: 6), isNewlyPlaced: false),
            .init(brick: .character("t"), position: .init(row: 6, column: 6), isNewlyPlaced: false),
            .init(brick: .character("i"), position: .init(row: 7, column: 6), isNewlyPlaced: false),
            .init(brick: .character("n"), position: .init(row: 8, column: 6), isNewlyPlaced: false),
            .init(brick: .character("s"), position: .init(row: 9, column: 6), isNewlyPlaced: true)
        ]
        
        assert(rankingWords.wordsToRank.count == 1)
        assert(rankingWords.wordsToRank.contains(martinsRankingControl))
    }
}
