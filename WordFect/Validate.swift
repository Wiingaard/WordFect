//
//  Validate.swift
//  WordFect
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class Validate {
    
    struct CrossWordsResult {
        let originalWord: [PlacedBrick]
        let crossWords: [CrossWord]
    }
    
    struct CrossWord: Equatable {
        let crossingIndex: Int
        let word: [FixedBrick]
    }
    
    static func validate(
        _ results: Search.PositionSearch,
        list: [String],
        bricks: Search.Bricks
    ) -> Search.PositionSearch {
        return Search.PositionSearch(
            horizontal: validateDirection(results.horizontal, list: list, bricks: bricks),
            vertical: validateDirection(results.vertical, list: list, bricks: bricks)
        )
    }
    
    static func validateDirection(
        _ result: Search.DirectionSearch,
        list: [String],
        bricks: Search.Bricks
    ) -> Search.DirectionSearch {
        
        result.results
            .filter { isValidWord($0, list: list) }
        
        fatalError()
    }
    
    static func isValidWord(_ word: [PlacedBrick], list: [String]) -> Bool {
        let wordString = String(word.map { $0.character })
        return list.contains(wordString)
    }
    
    static func findCrossWords(
        _ word: [PlacedBrick],
        wordDirection: MatrixDirection,
        position: MatrixIndex,
        bricks: Search.Bricks
    ) -> CrossWordsResult {
        var crossIndex = 0
        let crossWords = word.reduce(into: [CrossWord]()) { (result, next) in
            let word = findWord(
                position.move(wordDirection, count: crossIndex),
                direction: wordDirection.orthogonal,
                bricks: bricks
            )
            if (word.count > 1) {
                result.append(.init(crossingIndex: crossIndex, word: word))
            }
            crossIndex += 1
        }
        return .init(originalWord: word, crossWords: crossWords)
    }
    
    static func findWord(
        _ position: MatrixIndex,
        direction: MatrixDirection,
        bricks: Search.Bricks
    ) -> [FixedBrick] {
        
        let characterIndex = position[direction]
        let line = bricks[direction, position[direction.orthogonal]]
        
        let slices = line.enumerated().split { $1 == nil }
        let matchingSlice = slices.first { slice -> Bool in
            slice.contains { (offset, element) -> Bool in
                offset == characterIndex
            }
        }
        
        guard let match = matchingSlice else { return [] }
        
        return match.compactMap { (offset, element) -> FixedBrick? in
            guard let brick = element else { return nil }
            return FixedBrick.init(brick: brick, index: offset - characterIndex)
        }
    }
    
}
