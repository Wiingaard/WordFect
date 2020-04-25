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
    
    var value: Int {
        switch self {
        case .joker: return 0
        case .character(let char): return Rank.value(for: char)
        }
    }
    
    static func from(_ char: Character) -> PlacedBrick? {
        if allowedCharacters.contains(char) {
            return .character(char)
        } else if allowedCharacters.uppercased().contains(char) {
            return .joker(Character(String(char).lowercased()))
        } else {
            return nil
        }
    }
    
    static let allowedCharacters = "abcdefghijklmnopqrstuvxyzæøå"
    
}

enum FieldBrick: MatrixDumpable {
    case empty
    case bonus(BonusPosition)
    case placed(PlacedBrick)
    case newlyPlaced(PlacedBrick)
    case cursor(MatrixDirection)
    case tray(TrayBrick)
    case trayEmpty
    
    static func from(placed: PlacedBrick?, board: BoardPosition) -> FieldBrick {
        if let placed = placed {
            return .placed(placed)
        } else {
            return .from(board: board)
        }
    }
    
    static func from(board: BoardPosition) -> FieldBrick {
        switch board {
        case .bonus(let bonus): return .bonus(bonus)
        case .empty: return .empty
        }
    }
    
    var dumpable: String {
        switch self {
        case .empty: return "   "
        case .bonus(let pos): return " " + pos.dumpable
        case .placed(let pla): return " " + pla.dumpable
        case .newlyPlaced(let pla): return "_" + pla.dumpable
        case .cursor(let dir): return dir == .vertical ? "VER" : "HOR"
        case .tray, .trayEmpty: return "XXX"
        }
    }
}

struct FixedBrick: Equatable {
    /// A brick placed on a line
    let brick: PlacedBrick
    /// The brick index from the beginning of the line
    let index: Int
}

struct Bricks {
    static let emptyLine = Matrix<PlacedBrick?>.Line(repeating: nil, count: Board.size)
    static let empty = Matrix<PlacedBrick?>.Grid.init(repeating: emptyLine, count: Board.size)
}
