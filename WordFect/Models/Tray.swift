//
//  Tray.swift
//  WordFect
//
//  Created by Martin Wiingaard on 13/03/2022.
//  Copyright © 2022 Wiingaard. All rights reserved.
//

import Foundation
import Combinatorics

//let jokerSet = "abcdefghijklmnopqrstuvxyzæøå"
let jokerSet = "xyz"

class Tray {
    let bricks: [TrayBrick]
    
    init(bricks: [TrayBrick]) {
        self.bricks = bricks
    }
    
    lazy private(set) var bricksPermutations: Set<[PlacedBrick2]> = {
        // Turn potential jokers into concrete characters.
        let sets = permutationSets()
        
        var permutatedBrickWord = [[PlacedBrick2]]()
        
        sets.forEach { permutationSet in
            for size in 1...bricks.count {
                Permutation(of: permutationSet, size: size).forEach { word in
                    permutatedBrickWord.append(word)
                }
            }
        }
        
        return Set(permutatedBrickWord)
    }()
    
    /// Adds jokers to make Unique "potential" trays combinations.
    /// If there's on jokers, the return will simply be the tray.
    /// Not considering order of bricks.
    /// tray: [a,b,c] => [[a,b,c]]
    /// tray: [a,b] + 1 joker => [[a,b,a]-->[a,b,å]]
    private func permutationSets() -> [[PlacedBrick2]] {
        let charactersInTray = bricks.compactMap { brick -> PlacedBrick2? in
            switch brick {
            case .character(let char): return .character(char, fromTray: true)
            case .joker: return nil
            }
        }
        
        let jokersInTray = bricks.filter { $0.isJoker }.count
        
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
