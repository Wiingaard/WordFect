//
//  Brick.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

enum TrayBrick: CustomStringConvertible {
    case character(Character)
    case joker
    
    var isJoker: Bool {
        switch self {
        case .character: return false
        case .joker: return true
        }
    }

    var isCharacter: Bool {
        switch self {
        case .character: return true
        case .joker: return false
        }
    }
    
    var description: String {
        switch self {
        case .character(let character): return character.lowercased()
        case .joker: return "_"
        }
    }
}

enum PlacedBrick: MatrixDumpable, Hashable {
    case joker(Character)
    case character(Character)
    
    var isJoker: Bool {
        switch self {
        case .character: return false
        case .joker: return true
        }
    }

    var isCharacter: Bool {
        switch self {
        case .character: return true
        case .joker: return false
        }
    }
    
    var character: Character {
        switch self {
        case let .character(c), let .joker(c): return c
        }
    }
    
    var dumpable: String {
        switch self {
        case .character(let character): return " " + character.lowercased()
        case .joker(let character): return " " + character.uppercased()
        }
    }
    
}
