//
//  Validate.swift
//  WordFect
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class Validate {
    
    /// Final result from validating a position search
    struct PositionResult {
        let horizontal: [ValidatedResult]
        let vertical: [ValidatedResult]
        let position: MatrixIndex
    }
    
    /// Holding a potential validatied Result. Both the actual result `word` and the `crossword` touching the word that also must validated
    struct ValidatedResult {
        /// The search result
        let word: [PlacedBrick]
        /// Crossword crossing the `word`
        let crossWords: [CrossWord]
    }
    
    /// Describing a crossword in relation to it's word
    struct CrossWord: Equatable {
        /// Describing where on the `word` this crossword is crossing
        let crossingIndex: Int
        /// The actual crossword, with indicies defining where the characters are placed in relation to the `word`
        let word: [FixedBrick]
    }
    
    /// Validated the all the horizontal and vertical search results. Validates both the actual results and potential crosswords found in `bricks`. Validated according to `list`.
    static func validate(
        _ results: Search.PositionResult,
        list: List,
        bricks: Search.Bricks
    ) -> PositionResult {
        return PositionResult.init(
            horizontal: validateDirectionSearch(results.horizontal, list: list, bricks: bricks),
            vertical: validateDirectionSearch(results.vertical, list: list, bricks: bricks),
            position: results.horizontal.origin
        )
    }
    
    /// Main Validation logic. Ensures that a result is valid, and all potential crosswords are valid.
    static func validateDirectionSearch(
        _ result: Search.DirectionSearch,
        list: List,
        bricks: Search.Bricks
    ) -> [ValidatedResult] {
        var validatedResults = [ValidatedResult]()
        
        for word in result.results {
            guard list.contains(word) else { continue }
            
            let crossWords = findCrossWords(
                word,
                wordDirection: result.direction,
                position: result.origin,
                bricks: bricks
            )
            
            let hasInvalidCrossWord = crossWords.crossWords.contains { crossWord in
                !list.contains(crossWord.word)
            }
            
            guard !hasInvalidCrossWord else { continue }
            
            validatedResults.append(crossWords)
        }
        
        return validatedResults
    }
    
    /// Finding all crosswords to a given `word` located at `position` amount the current `bricks`. Does not validate crosswords, but crosswords must have more than 1 character.
    static func findCrossWords(
        _ word: [PlacedBrick],
        wordDirection: MatrixDirection,
        position: MatrixIndex,
        bricks: Search.Bricks
    ) -> ValidatedResult {
        var crossIndex = 0
        let crossWords = word.reduce(into: [CrossWord]()) { (result, next) in
            let word = findWord(
                at: position.move(wordDirection, count: crossIndex),
                brick: next,
                direction: wordDirection.orthogonal,
                bricks: bricks
            )
            if (word.count > 1) {
                result.append(.init(crossingIndex: crossIndex, word: word))
            }
            crossIndex += 1
        }
        return .init(word: word, crossWords: crossWords)
    }
    
    /// Inserts `brick` at the `position` and searches the line at the current `bricks`. Returns the word found (seperated by nil), if if't more than 1 character long.
    static func findWord(
        at position: MatrixIndex,
        brick: PlacedBrick,
        direction: MatrixDirection,
        bricks: Search.Bricks
    ) -> [FixedBrick] {
        
        let characterIndex = position[direction]
        var line = bricks[direction, position[direction.orthogonal]]
        line[position[direction]] = brick
        
        let slices = line.enumerated().split { $1 == nil }
        let matchingSlice = slices.first { slice -> Bool in
            slice.contains { (offset, element) -> Bool in
                offset == characterIndex
            }
        }
        
        guard let match = matchingSlice, match.count > 1 else { return [] }
        
        return match.compactMap { (offset, element) -> FixedBrick? in
            guard let brick = element else { return nil }
            return FixedBrick.init(brick: brick, index: offset - characterIndex)
        }
    }
}
