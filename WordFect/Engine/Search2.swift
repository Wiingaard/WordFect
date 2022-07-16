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
    
    struct Word {
        let origin: MatrixIndex
        let direction: MatrixDirection
        let line: Line<PlacedBrick2>
    }
    
    struct Solution {
        let word: Word
        let crosswords: [Word]
    }
    
    /// Searches from `position` in `direction`.
    /// Using all permutations of the `tray`.
    /// Finding potential words within the currencly places `bricks`.
    /// Only taking word that start on the `position`, regardless if it's comming from the `tray` or already placed in `bricks`.
    ///
    func search() -> [Solution] {
        return []
    }

}

/// For a position
/// 1. Check if the position can be a starting brick in a word (if there are no predesessor bricks)
/// 2. Find a possible word
/// 3. Find formed crosswords for all newly placed bricks
///
/// Actually, we don't even need the tray here,
/// we just need to know how many bricks are in the tray.
/// A word could then consist for currently places bricks and wildcards of tray bricks.
/// Because we're searching for words than align with current bricks,
/// let's also find the all crosswords that was formed by the tray bricks.
