//
//  PlacedBrick2.swift
//  WordFect
//
//  Created by Martin Wiingaard on 13/03/2022.
//  Copyright © 2022 Wiingaard. All rights reserved.
//

import Foundation

struct PlacedBrick2: MatrixDumpable, Hashable {
    let character: Character
    let isJoker: Bool
    let isFromTray: Bool
    
    init(character: Character, isJoker: Bool = false, isFromTray: Bool = false) {
        self.character = character
        self.isJoker = isJoker
        self.isFromTray = isFromTray
    }
    
    var dumpable: String {
        return " " + character.lowercased()
    }
    
    var value: Int {
        guard !isJoker else {
            return 0
        }
        return Rank.value(for: character)
    }
    
    init?(_ char: Character) {
        if Self.allowedCharacters.contains(char) {
            self = .character(char)
        } else if Self.allowedCharacters.uppercased().contains(char) {
            self = .joker(Character(String(char).lowercased()))
        } else {
            return nil
        }
    }
    
    init?(_ field: FieldBrick) {
        switch field {
        case .bonus, .cursor, .empty, .tray, .trayEmpty:
            return nil
        case .placed(let brick):
            self = brick.asPlacedBrick2(isFromTray: false)
        case .newlyPlaced(let brick):
            self = brick.asPlacedBrick2(isFromTray: true)
        }
    }
    
    static func joker(_ char: Character, fromTray: Bool = false) -> PlacedBrick2{
        .init(character: char, isJoker: true, isFromTray: fromTray)
    }
    
    static func character(_ char: Character, fromTray: Bool = false) -> PlacedBrick2{
        .init(character: char, isJoker: false, isFromTray: fromTray)
    }
    
    static let allowedCharacters = "abcdefghijklmnopqrstuvxyzæøå"
}

extension PlacedBrick {
    func asPlacedBrick2(isFromTray: Bool) -> PlacedBrick2 {
        .init(character: self.character, isJoker: self.isJoker, isFromTray: isFromTray)
    }
}
