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
    
    @Published var fields: [FieldBrick] = Array<TrayBrick?>(repeating: nil, count: Tray.size).map(FieldBrick.from)
    @Published var isEditing: Bool = false
    
    func didTap(_ position: Int) {
        isEditing = true
    }
    
    func didInputKey(_ input: Keyboard.Output) {
        print(input)
    }
    
    func finishEditing() {
        isEditing = false
    }
    
}
