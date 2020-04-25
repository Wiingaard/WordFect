//
//  PlayingField.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

struct Cursor {
    let direction: MatrixDirection
    let position: MatrixIndex
    
    func progress(_ progress: MatrixIndex.Progress) -> Cursor? {
        guard let nextPosition = position.iterate(progress, direction) else {
            return nil
        }
        return .init(direction: direction, position: nextPosition)
    }
}

class PlayingField: ObservableObject {
    
    let board: Matrix<BoardPosition> = Matrix(Board.standart)
    var bricks: Matrix<PlacedBrick?> = Matrix(Bricks.empty)
    var newlyPlaced: Matrix<PlacedBrick?> = Matrix(Bricks.empty)
    
    var cursor: Cursor? = nil
    
    @Published var editFieldDirection: MatrixDirection = .horizontal
    @Published var isEditing: Bool = false
    @Published var fields: Matrix<FieldBrick> = PlayingField.empty
    
    func didTapField(_ position: MatrixIndex) {
        cursor = .init(direction: editFieldDirection, position: position)
        isEditing = true
        fields[position] = .cursor(editFieldDirection)
    }
    
    func didInputKey(_ key: Keyboard.Output) {
        guard let cursor = cursor else { return }
        objectWillChange.send()
        
        switch key {
        case .character(let char):
            if let brick = PlacedBrick.from(char) {
                fields[cursor.position] = .newlyPlaced(brick)
            } else {
                fields[cursor.position] = currentField(at: cursor.position)
            }
            progress(cursor: cursor, .forward)
            
        case .delete:
            fields[cursor.position] = currentField(at: cursor.position)
            progress(cursor: cursor, .backward)
            
        case .return:
            self.cursor = nil
            isEditing = false
        }
    }
    
    private func progress(cursor: Cursor, _ progress: MatrixIndex.Progress) {
        if let nextCursor = cursor.progress(progress) {
            fields[nextCursor.position] = .cursor(nextCursor.direction)
            self.cursor = nextCursor
        } else {
            self.cursor = nil
            isEditing = false
        }
    }
    
    private func currentField(at position: MatrixIndex) -> FieldBrick {
        return FieldBrick.from(placed: bricks[position], board: board[position])
    }
}

extension PlayingField {
    
    static let empty = Matrix(Board.standart).map(FieldBrick.from)
    
}
