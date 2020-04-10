//
//  Rank.swift
//  WordFect
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class Rank {
    
    typealias Bricks = Matrix<PlacedBrick?>
    typealias Board = Matrix<BoardPosition>
    
    struct PositionResults {
        
    }
    
    struct RankingBrick {
        let brick: PlacedBrick
        let position: MatrixIndex
        let isNewlyPlaced: Bool
    }
    
    static func calculateScores(for results: Validate.PositionResult) -> PositionResults {
        results.horizontal[1]
        fatalError()
    }
    
    static func calculateScore(for word: [RankingBrick], board: Board) -> Int {
        var wordMultiplier = 1
        var accumulatedLetterValue = 0
        word.forEach { brick in
            if brick.isNewlyPlaced {
                let boardPosition = board[brick.position]
                accumulatedLetterValue += brick.brick.value * boardPosition.letterMultiplier
                wordMultiplier *= boardPosition.wordMultiplier
            } else {
                accumulatedLetterValue += brick.brick.value
            }
        }
        return accumulatedLetterValue * wordMultiplier
    }
    
    static func findNewlyPlacedBricks(
        _ word: [PlacedBrick],
        direction: MatrixDirection,
        position: MatrixIndex,
        bricks: Bricks
    ) -> [FixedBrick] {
        let linePositionOnBoard = position[direction.orthogonal]
        let wordPositionOnLine = position[direction]
        
        let line = bricks[direction, linePositionOnBoard]
        let currentWordFromBricks = line[wordPositionOnLine..<wordPositionOnLine + word.count]
        return zip(currentWordFromBricks, word).enumerated().compactMap { (offset, pair) -> FixedBrick? in
            return pair.0 == nil
                ? FixedBrick.init(brick: pair.1, index: offset)
                : nil
        }
    }
    
    static func value(for char: Character) -> Int {
        switch char {
        case "a","e","n","r": return 1
        case "d","l","o","s","t": return 2
        case "b","f","g","i","k","u": return 3
        case "h","j","m","p","v","y","æ","ø","å": return 4
        case "c","x": return 8
        case "z": return 9
        default: fatalError("Character '\(char)' is not valid in danish wordfeud")
        }
    }
}
