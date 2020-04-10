//
//  List.swift
//  WordFect
//
//  Created by Martin Wiingaard on 09/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class List {
    
    private let storage: [String]
    
    init(_ storage: [String]) {
        self.storage = storage
    }
    
    func contains(_ word: String) -> Bool {
        storage.contains(word)
    }
    
    func contains(_ word: [PlacedBrick]) -> Bool {
        contains(String(word.map { $0.character }))
    }
    
    func contains(_ word: [FixedBrick]) -> Bool {
        contains(String(word.map { $0.brick.character }))
    }
}
