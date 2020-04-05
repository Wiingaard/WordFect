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
    
    struct PositionSearch {
        let horizontal: DirectionSearch
        let vertical: DirectionSearch
    }
    
    func searchPosition(_ position: MatrixIndex, tray: Tray) -> PositionSearch {
        return .init(
            horizontal: searchDirection(position, direction: .horizontal, tray: tray),
            vertical: searchDirection(position, direction: .vertical, tray: tray)
        )
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
    
    func searchDirection(_ position: MatrixIndex, direction: MatrixDirection, tray: Tray) -> DirectionSearch {
        // Can be optimized:
        // - Allow `potentialMatches` to take minLength parameter if no characters is within proximity
        
        /// Check for predecessor brick
        if position[direction] > 0 && bricks[position.move(direction, count: -1)] != nil {
            return .empty(position, direction: direction)
        }
        
        let searchLine = getSearchLine(direction, position: position)
        let words = PlayingField.potentialMatches(
            tray: tray,
            fixed: searchLine.bricks,
            maxLength: searchLine.length,
            minLength: 1
        )
        return DirectionSearch(
            origin: position,
            direction: direction,
            fixedBricks: searchLine.bricks,
            length: searchLine.length,
            results: words
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
        
        let line = bricks[direction, position[direction.orthogonal]]
        let charactersFromPosition = line[position[direction]..<Board.size]
        
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
    
    /// Determins if a given permutation set with fixed bricks can reach a given length
    static func canReachLength(_ minSize: Int, permutationSetSize: Int, fixed: [FixedBrick]) -> Bool {
        let fixedWithinRange = fixed.filter { $0.index < minSize }.count
        return fixedWithinRange + permutationSetSize >= minSize
    }
    
    /// Finds all potential word matched for a given line.
    static func potentialMatches(tray: Tray, fixed: [FixedBrick], maxLength: Int, minLength: Int) -> Set<[PlacedBrick]> {
        guard maxLength > fixed.count else { return [] }
        let max = min(maxLength, tray.count + fixed.count)
        
        var permutations = [Permutation<PlacedBrick>]()
        for size in 1...max {
            permutationSets(tray: tray).forEach { set in
                if canReachLength(minLength, permutationSetSize: size, fixed: fixed) {
                    permutations.append(Permutation(of: set, size: size))
                }
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
