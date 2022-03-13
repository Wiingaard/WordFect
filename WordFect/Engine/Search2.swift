//
//  Search2.swift
//  WordFect
//
//  Created by Martin Wiingaard on 13/03/2022.
//  Copyright © 2022 Wiingaard. All rights reserved.
//

import Foundation
import Combinatorics

/**
 For every position on the board it does (should):
 1. Find all the permutations on the tray also considering jokers.
 2. Find the minimum and maximum length a word can be by considering which bricks are places on the board including rows in close proximity to search position.
 3. Make all potential words matching the length requirements by merging tray bricks with placed bricks.
 */
struct Search2 {
    let position: MatrixIndex
    let direction: MatrixDirection
    let tray: [TrayBrick]
    let bricks: Matrix<PlacedBrick?>
    
    struct PotentialWord {
        let origin: MatrixIndex
        let direction: MatrixDirection
        let word: Line<PlacedBrick2>
    }
    
    /// Searches from `position` in `direction`.
    /// Using all permutations of the `tray`.
    /// Finding potential words within the currencly places `bricks`.
    /// Only taking word that start on the `position`, regardless if it's comming from the `tray` or already placed in `bricks`.
    ///
//    func search() -> [PotentialWord] {
//
//    }
//    let jokerSet = "abcdefghijklmnopqrstuvxyzæøå"
    let jokerSet = "xyz"
    
    func makeTrayPermutations() -> [[TrayBrick]] {
//        let jokersInTray = tray.filter { $0.isJoker }.count
//        let charactersInTray = tray.compactMap { brick -> Character? in
//            switch brick {
//            case .character(let char): return char
//            case .joker: return nil
//            }
//        }
        
//        var permutations = [Permutation<PlacedBrick>]()
//        for size in 1...max {
//            permutationSets(tray: tray).forEach { set in
//                if canReachLength(minLength, permutationSetSize: size, fixed: fixed) {
//                    permutations.append(Permutation(of: set, size: size))
//                }
//            }
//        }
        
        let lol = permutationSets()
        print("permutationSets:", lol.map { $0.map { $0.character } })
        let berp = permutations(of: lol, length: tray.count)
        print("permutations(of:,length:)", berp.map { $0.map { $0.character } })
        return []
    }
    
    
    func permutations(of sets: [[PlacedBrick2]], length: Int) -> [[PlacedBrick2]] {
        var _permutations = [Permutation<PlacedBrick2>]()
        sets.forEach { permutationSet in
            for size in 1...length {
                _permutations.append(Permutation(
                    of: permutationSet,
                    size: size)
                )
            }
        }
        
        var allPermutations: [[PlacedBrick2]] = []
        _permutations.forEach { permutation in
            permutation.forEach { p in
                let berp: [PlacedBrick2] = p.map { $0 }
                allPermutations.append(berp)
            }
        }

//        let mojn = Set(_permutations.flatMap { permutation -> [[PlacedBrick]] in
//            return permutation.map { bricks in bricks.map { $0 } }
//        })
        return allPermutations
    }
    
    /// Adds jokers to make Unique "potential" trays combinations.
    /// If there's on jokers, the return will simply be the tray.
    /// Not considering order of bricks.
    /// tray: [a,b,c] => [[a,b,c]]
    /// tray: [a,b] + 1 joker => [[a,b,a]-->[a,b,å]]
    func permutationSets() -> [[PlacedBrick2]] {
        let charactersInTray = tray.compactMap { brick -> PlacedBrick2? in
            switch brick {
            case .character(let char): return .character(char, fromTray: true)
            case .joker: return nil
            }
        }
        
        let jokersInTray = tray.filter { $0.isJoker }.count
        
        if (jokersInTray > 0) {
            return BaseN(of: jokerSet, size: jokersInTray).map { jokerChars in
                return charactersInTray + jokerChars.map {
                    PlacedBrick2(character: $0, isJoker: true, isFromTray: true)
                }
            }
        } else {
            return [charactersInTray]
        }
    }
}
