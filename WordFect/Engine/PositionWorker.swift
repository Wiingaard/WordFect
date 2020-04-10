//
//  PositionWorker.swift
//  WordFect
//
//  Created by Martin Wiingaard on 10/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

struct PositionWorker {
    let position: MatrixIndex
    let list: List
    let bricks: Matrix<PlacedBrick?>
    let board: Matrix<BoardPosition>
    let tray: Tray
    
    func analyze() -> [Rank.RankedResult] {
        let searchResults = Search.searchPosition(position, bricks: bricks, tray: tray)
        let validateResults = Validate.validate(searchResults, list: list, bricks: bricks)
        let rankResults = Rank.calculateScores(for: validateResults, bricks: bricks, board: board)
        return rankResults
    }
}
