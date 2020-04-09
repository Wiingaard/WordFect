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
    
    struct PositionResults {
        
    }
    
    static func calculateScores(for results: Validate.PositionResult) -> PositionResults {
        results.horizontal[1]
        fatalError()
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
    
}
