//
//  Search.swift
//  WordFect
//
//  Created by Martin Wiingaard on 05/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import Combinatorics

class Search {
    
    /// Final result from searching a position
    struct PositionResult {
        let horizontal: DirectionSearch
        let vertical: DirectionSearch
        let position: MatrixIndex
    }
    
    struct SearchLine {
        /// The bricks placed on the line
        let bricks: [FixedBrick]
        /// The max length of the line
        let length: Int
    }
    
    struct DirectionSearch {
        /// The starting point of the search
        let origin: MatrixIndex
        /// The direction of the search
        let direction: MatrixDirection
        /// Any fixed bricks found between the starting point and end of the line
        let fixedBricks: [FixedBrick]
        /// Distance from the starting point to the end of the line
        let length: Int
        /// Potential matches found on the line. With fixed bricks inserted.
        let results: Set<[PlacedBrick]>
        
        static func empty(_ origin: MatrixIndex, direction: MatrixDirection) -> DirectionSearch {
            .init(origin: origin, direction: direction, fixedBricks: [], length: 0, results: [])
        }
    }
    
    /// Main Matrix type in Search
    typealias Bricks = Matrix<PlacedBrick?>
    
    /// An honest tray. A tray without any jokers will result in a single PermutationSet
    typealias PermutationSet = [PlacedBrick]
    
    /// All the characters that a joker can be turned into
    static let jokerSet = "abcdefghijklmnopqrstuvxyzæøå"
    
    static func searchPosition(_ position: MatrixIndex, bricks: Bricks, tray: TrayBricks) -> PositionResult {
        return .init(
            horizontal: searchDirection(position, direction: .horizontal, tray: tray, bricks: bricks),
            vertical: searchDirection(position, direction: .vertical, tray: tray, bricks: bricks),
            position: position
        )
    }
    
    /// Searches in one `direction` form the `position`. Will not find any results if the position has a predecessors brick, or if it doesn't have any other bricks in proximity, acording to Wordfeud rules.
    static func searchDirection(
        _ position: MatrixIndex,
        direction: MatrixDirection,
        tray: TrayBricks,
        bricks: Bricks
    ) -> DirectionSearch {
        /// Check for predecessor brick
        if position[direction] > 0 && bricks[position.move(direction, count: -1)] != nil {
            return .empty(position, direction: direction)
        }
        
        /// The minumum required length of results (Checking bricks in proximity)
        guard let minSearchLength = findMinimumSearchLength(from: position, direction: direction, bricks: bricks) else {
            return .empty(position, direction: direction)
        }
        
        let searchLine = getSearchLine(direction, position: position, bricks: bricks)
        let words = Self.potentialMatches(
            tray: tray,
            fixed: searchLine.bricks,
            maxLength: searchLine.length,
            minLength: minSearchLength
        )
        return DirectionSearch(
            origin: position,
            direction: direction,
            fixedBricks: searchLine.bricks,
            length: searchLine.length,
            results: words
        )
    }
    
    /// Length from `from` to next brick in `line`
    static func lengthToNextBrick(on line: [PlacedBrick?], from: Int) -> Int? {
        let toElementIndex: (Int, PlacedBrick?) -> Int? = { (offset, element) in
            element == nil ? nil : offset
        }
        
        return line.enumerated()
            .filter { $0.offset > from }
            .compactMap(toElementIndex)
            .min()
            .map { $0 - from }
    }
    
    /// Check the line that `position` is on, and the one before and after, and returns the minimum length that a result needs to be from the position.
    static func findMinimumSearchLength(
        from position: MatrixIndex,
        direction: MatrixDirection,
        bricks: Bricks
    ) -> Int? {
        var potentialMinLength = [Int]()
        
        func checkLine(offset: Int) {
            let movedLinePosition = position.move(direction.orthogonal, count: offset)
            if movedLinePosition.isWithinBoard() {
                let line = bricks[direction, movedLinePosition[direction.orthogonal]]
                if let length = lengthToNextBrick(on: line, from: movedLinePosition[direction]) {
                    potentialMinLength.append(offset == 0 ? length : length + 1)
                } else if bricks[position] != nil {
                    potentialMinLength.append(1)
                }
            }
        }
        
        checkLine(offset: -1)
        checkLine(offset: 0)
        checkLine(offset: 1)
        
        return potentialMinLength.min()
    }
    
    /// From a given `position` and `direction` on the board, return a line to be searched.
    static func getSearchLine(
        _ direction: MatrixDirection,
        position: MatrixIndex,
        bricks: Bricks
    ) -> SearchLine {
        
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
    
    /// Determins if a given permutation set with fixed bricks can reach a given length
    static func canReachLength(
        _ minSize: Int,
        permutationSetSize: Int,
        fixed: [FixedBrick]
    ) -> Bool {
        let fixedWithinRange = fixed.filter { $0.index < minSize }.count
        return fixedWithinRange + permutationSetSize >= minSize
    }
    
    /// Finds all potential word matched for a given line.
    static func potentialMatches(
        tray: TrayBricks,
        fixed: [FixedBrick],
        maxLength: Int,
        minLength: Int
    ) -> Set<[PlacedBrick]> {
        guard maxLength > fixed.count else { return [] }
        let max = Swift.min(maxLength, tray.count + fixed.count)
        
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
    
    /// Purpose is to turn potential jokers in the Tray, into different combinations of possible honest trays.
    static func permutationSets(tray: TrayBricks) -> [PermutationSet] {
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
