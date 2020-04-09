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
    
}
