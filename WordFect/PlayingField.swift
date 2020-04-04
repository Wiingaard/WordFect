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
    
    func searchPosition(_ position: MatrixIndex, tray: Tray) -> [MatchLine] {
        let horizontalMatches: [MatchLine]
        if position.column > 0 && bricks[position.move(.horizontal, count: -1)] != nil {
            // Found horizontal predesessor
            horizontalMatches = []
        } else {
            horizontalMatches = []
        }
        
        let verticalMatches: [MatchLine]
        if position.row > 0 && bricks[position.move(.vertical, count: -1)] != nil {
            // Found vertical predesessor
            verticalMatches = []
        } else {
            verticalMatches = []
        }
        
        return horizontalMatches + verticalMatches
    }
    
    struct SearchLine {
        let bricks: [FixedBrick]
        let length: Int
    }
    
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
    
    // TODO: Align FixedCharecter -> FixedBrick
    struct FixedBrick {
        let brick: PlacedBrick
        let index: Int
    }
    
    typealias FixedCharecter = (character: Character, index: Int)
    
    /// Finds all potential word matched for a given line.
    static func potentialMatches(tray: Tray, fixed: [FixedCharecter], lineLength: Int) -> Set<[PlacedBrick]> {
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
    
    /// Inserts the `fixed` characters into `string` as long as they are connected to the beginning of the string.
    /// Assumes that fixed is sorted after assending index
    static func adjust(string: inout [PlacedBrick], fixed: [FixedCharecter]) {
        fixed.forEach { (char, index) in
            if (index < string.count + 1) {
                string.insert(.character(char), at: index)
            }
        }
    }
    
    /// Inserts the `fixed` characters into `string` as long as they are connected to the beginning of the string.
    /// Assumes that fixed is sorted after assending index
    static func adjust(string: [PlacedBrick], fixed: [FixedCharecter]) -> [PlacedBrick] {
        var _string = string
        fixed.forEach { (char, index) in
            if (index < _string.count + 1) {
                _string.insert(.character(char), at: index)
            }
        }
        return _string
    }
    
    static let jokerSet = "abcdefghijklmnopqrstuvxyzæøå"
    
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

struct MatchLine {
    typealias Word = [PlacedBrick]

    let origin: MatrixIndex
    let direction: MatrixDirection
    let word: Word
}
