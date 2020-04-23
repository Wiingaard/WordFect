//
//  PlayingField.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

struct Edit {
    let direction: MatrixDirection
    let position: MatrixIndex
    
    static let initial: Edit = .init(
        direction: .horizontal,
        position: .init(row: 0, column: 0)
    )
}

class PlayingField: ObservableObject {
    
    let board: Matrix<BoardPosition> = Matrix(Board.standart)
    var bricks: Matrix<PlacedBrick?> = Matrix(Bricks.empty)
    var newlyPlaced: Matrix<PlacedBrick?> = Matrix(Bricks.empty)
    
    @Published var editing: Edit? = nil
    @Published var isEditing: Bool = false
    
    @Published var fields: Matrix<FieldBrick> = PlayingField.empty
    
}

extension PlayingField {
    
    static let empty = Matrix(Board.standart).map { brick -> FieldBrick in
        switch brick {
        case .bonus(let bonus): return FieldBrick.bonus(bonus)
        case .empty: return FieldBrick.empty
        }
    }
    
}
