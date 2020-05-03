//
//  Tray.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

typealias TrayBricks = [TrayBrick]

class Tray: ObservableObject {
    static let size = 7
    
    static let emptyBricks = Line(
        Array<TrayBrick?>(repeating: nil, count: size)
    )
    
    static let emptyFields = Line(
        Array<FieldBrick>(repeating: .trayEmpty, count: size)
    )
    
    struct Cursor {
        let position: Int
        
        func progress(_ progress: MatrixIndex.Progress) -> Cursor? {
            let nextPosition = position + progress.unitValue
            guard nextPosition >= 0 && nextPosition < Tray.size else { return nil }
            return Cursor(position: nextPosition)
        }
    }
    
    var bricks: Line<TrayBrick?> = Tray.emptyBricks
    @Published var fields: Line<FieldBrick> = Tray.emptyFields
    @Published var isEditing: Bool = false
    
    private var cursor: Cursor? = nil
    
    func didTap(_ position: Int) {
        objectWillChange.send()
        isEditing = true
        if let cursor = self.cursor {
            let oldBrick = currentBrick(on: cursor.position)
            print("Old brick:", oldBrick)
            fields[position] = oldBrick
        }
        let newCursor = Cursor(position: position)
        fields[newCursor.position] = .cursor(.horizontal)
        self.cursor = newCursor
    }
    
    func didInputKey(_ input: Keyboard.Output) {
        guard let cursor = cursor else { return }
        objectWillChange.send()
        
        switch input {
        case .character(let char):
            if let brick = PlacedBrick.from(char) {
                fields[cursor.position] = .newlyPlaced(brick)
            } else {
                fields[cursor.position] = currentBrick(on: cursor.position)
            }
            progress(cursor: cursor, .forward)
            
        case .delete:
            fields[cursor.position] = .trayEmpty
            progress(cursor: cursor, .backward)
            
        case .return:
            finishEditing()
        }
    }
    
    func currentBrick(on position: Int) -> FieldBrick {
        return FieldBrick.from(tray: bricks[position])
    }
    
    func finishEditing() {
        cursor = nil
        isEditing = false
        
        bricks = fields.map(TrayBrick.from)
        
        Line<Void>.forEach { position in
            fields[position] = FieldBrick.from(tray: bricks[position])
        }
    }
    
    func beginEditing() {
        let cursor = Cursor(position: 0)
        self.cursor = cursor
        isEditing = true
        fields[cursor.position] = FieldBrick.cursor(.horizontal)
    }
    
    private func progress(cursor: Cursor, _ progress: MatrixIndex.Progress) {
        if let nextCursor = cursor.progress(progress) {
            fields[nextCursor.position] = .cursor(.horizontal)
            self.cursor = nextCursor
        } else {
            finishEditing()
        }
    }
}