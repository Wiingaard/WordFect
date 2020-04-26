//
//  PlayingField.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class PlayingField: ObservableObject {
    
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
    
    let board: Matrix<BoardPosition> = Matrix(Board.standart)
    var bricks: Matrix<PlacedBrick?> = Matrix(Bricks.empty)
    
    private var cursor: Cursor? = nil
    
    @Published var editFieldDirection: MatrixDirection = .horizontal
    @Published var isEditing: Bool = false
    @Published var fields: Matrix<FieldBrick> = PlayingField.empty
    
    func didTapField(_ position: MatrixIndex) {
        objectWillChange.send()
        if let cursor = cursor {
            if cursor.position == position {
                editFieldDirection = editFieldDirection.orthogonal
                fields[position] = .cursor(editFieldDirection)
                self.cursor = Cursor(direction: editFieldDirection, position: position)
            } else {
                fields[cursor.position] = currentField(at: cursor.position)
                let newCursor = Cursor.init(direction: cursor.direction, position: position)
                fields[newCursor.position] = .cursor(newCursor.direction)
                self.cursor = newCursor
            }
        } else {
            cursor = .init(direction: editFieldDirection, position: position)
            fields[position] = .cursor(editFieldDirection)
            isEditing = true
        }
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
            finishEditing()
        }
    }
    
    func finishEditing() {
        objectWillChange.send()
        if let cursor = cursor {
            fields[cursor.position] = currentField(at: cursor.position)
        }
        
        cursor = nil
        isEditing = false
        
        bricks = fields.map(PlacedBrick.from)
        Matrix<Void>.forEach { fields[$0] = currentField(at: $0) }
    }
    
    func beginEditing() {
        objectWillChange.send()
        let center = MatrixIndex.init(row: 7, column: 7)
        fields[center] = .cursor(editFieldDirection)
        cursor = Cursor(direction: editFieldDirection, position: center)
        isEditing = true
    }
    
    func changeDirection() {
        objectWillChange.send()
        editFieldDirection = editFieldDirection.orthogonal
        if let cursor = cursor {
            fields[cursor.position] = .cursor(editFieldDirection)
        }
    }
    
    private func progress(cursor: Cursor, _ progress: MatrixIndex.Progress) {
        if let nextCursor = cursor.progress(progress) {
            fields[nextCursor.position] = .cursor(nextCursor.direction)
            self.cursor = nextCursor
        } else {
            finishEditing()
        }
    }
    
    private func currentField(at position: MatrixIndex) -> FieldBrick {
        return FieldBrick.from(placed: bricks[position], board: board[position])
    }
}

extension PlayingField {
    
    static let empty = Matrix(Board.standart).map(FieldBrick.from)
    
}
