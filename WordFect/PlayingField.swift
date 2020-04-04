//
//  PlayingField.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import Combinatorics

class PlayingField {
    
    let board = Matrix<BoardPosition>.init(Board.standart)
    let bricks: Matrix<PlacedBrick?>
    
    init(bricks: Matrix<PlacedBrick?>.Grid) {
        self.bricks = Matrix<PlacedBrick?>.init(bricks)
    }
    
    struct SearchResult {
        let origin: MatrixIndex
        let direction: MatrixDirection
        let word: [PlacedBrick]
    }
    
    struct PositionSearch {
        let horizontal: DirectionSearch
        let vertical: DirectionSearch
    }
    
    struct DirectionSearch {
        let origin: MatrixIndex
        let direction: MatrixDirection
        let fixedBricks: [FixedBrick]
        let length: Int
        let results: Set<[PlacedBrick]>
        
        static func empty(_ origin: MatrixIndex, direction: MatrixDirection) -> DirectionSearch {
            .init(origin: origin, direction: direction, fixedBricks: [], length: 0, results: [])
        }
    }
    
    func searchPosition(_ position: MatrixIndex, tray: Tray) -> PositionSearch {
        // Can be optimized:
        // - Allow `potentialMatches` to take minLength parameter if no characters is within proximity
        
        let horizontalSearch: DirectionSearch
        if position.column > 0 && bricks[position.move(.horizontal, count: -1)] != nil {
            // Found horizontal predesessor
            horizontalSearch = DirectionSearch.empty(position, direction: .horizontal)
            
        } else {
            let searchLine = getSearchLine(.horizontal, position: position)
            let words = PlayingField.potentialMatches(tray: tray, fixed: searchLine.bricks, lineLength: searchLine.length)
            horizontalSearch = DirectionSearch(
                origin: position,
                direction: .horizontal,
                fixedBricks: searchLine.bricks,
                length: searchLine.length,
                results: words
            )
        }
        
        let verticalSearch: DirectionSearch
        if position.row > 0 && bricks[position.move(.vertical, count: -1)] != nil {
            // Found vertical predesessor
            verticalSearch = DirectionSearch.empty(position, direction: .vertical)
        } else {
            let searchLine = getSearchLine(.vertical, position: position)
            let words = PlayingField.potentialMatches(tray: tray, fixed: searchLine.bricks, lineLength: searchLine.length)
            verticalSearch = DirectionSearch(
                origin: position,
                direction: .vertical,
                fixedBricks: searchLine.bricks,
                length: searchLine.length,
                results: words
            )
        }
        
        return .init(
            horizontal: horizontalSearch,
            vertical: verticalSearch
        )
    }
    
    struct SearchLine {
        /// The bricks placed on the line
        let bricks: [FixedBrick]
        /// The max length of the line
        let length: Int
    }
    
    /// From a given `position` and `direction` on the board, return a line to be searched.
    func getSearchLine(_ direction: MatrixDirection, position: MatrixIndex) -> SearchLine {
        let charactersFromPosition: ArraySlice<PlacedBrick?>
        switch direction {
        case .horizontal:
            let line = bricks[direction, position.row]
            charactersFromPosition = line[position.column..<Board.size]
        case .vertical:
            let line = bricks[direction, position.column]
            charactersFromPosition = line[position.row..<Board.size]
        }
        
        let fixed = charactersFromPosition.enumerated().compactMap { (index,brick) -> FixedBrick? in
            guard let brick = brick else { return nil }
            return .init(brick: brick, index: index)
        }
        
        return .init(
            bricks: fixed,
            length: charactersFromPosition.count
        )
    }
    
    struct FixedBrick {
        /// A brick placed on a line
        let brick: PlacedBrick
        /// The brick index from the beginning of the line
        let index: Int
    }
    
    /// Finds all potential word matched for a given line.
    static func potentialMatches(tray: Tray, fixed: [FixedBrick], lineLength: Int) -> Set<[PlacedBrick]> {
        guard lineLength > fixed.count else { return [] }
        let maxLength = min(lineLength, tray.count + fixed.count)
        
        let permutationSets = Self.permutationSets(tray: tray)
        var permutations = [Permutation<PlacedBrick>]()
        
        for size in 1...maxLength {
            permutationSets.forEach { set in
                permutations.append(Permutation(of: set, size: size))
            }
        }
        
        return Set(permutations.flatMap { permutation -> [[PlacedBrick]] in
            return permutation.map { adjust(string: $0, fixed: fixed) }
        })
    }
    
    /// Inserts the `fixed` bricks into `string` as long as they are connected to the beginning of the string.
    /// Assumes that fixed is sorted after assending index
    static func adjust(string: [PlacedBrick], fixed: [FixedBrick]) -> [PlacedBrick] {
        var _string = string
        fixed.forEach { brick in
            if (brick.index < _string.count + 1) {
                _string.insert(brick.brick, at: brick.index)
            }
        }
        return _string
    }
    
    /// All the characters that a joker can be turned into
    static let jokerSet = "abcdefghijklmnopqrstuvxyzæøå"
    
    /// An honest tray. A tray without any jokers will result in a single PermutationSet
    typealias PermutationSet = [PlacedBrick]
    
    /// Purpose is to turn potential jokers in the Tray, into different combinations of possible honest trays.
    static func permutationSets(tray: Tray) -> [PermutationSet] {
        let charactersInTray = tray.compactMap { brick -> Character? in
            switch brick {
            case .character(let char): return char
            case .joker: return nil
            }
        }
        
        let jokersInTray = tray.filter { $0.isJoker }.count
        
        if (jokersInTray > 0) {
            return BaseN(of: jokerSet, size: jokersInTray).map { jokerChars in
                return charactersInTray.map(PlacedBrick.character) + jokerChars.map(PlacedBrick.joker)
            }
        } else {
            return [charactersInTray.map(PlacedBrick.character)]
        }
    }
}
