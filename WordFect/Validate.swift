//
//  Validate.swift
//  WordFect
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class Validate {
    
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
        fatalError()
    }
    
    static func isValidWord(_ word: [PlacedBrick], list: [String]) -> Bool {
        let wordString = String(word.map { $0.character })
        return list.contains(wordString)
    }
    
}
