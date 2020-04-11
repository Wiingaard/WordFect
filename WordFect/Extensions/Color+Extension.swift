//
//  Color+Extension.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

extension Color {
    
    // Bonus positions
    static let dlTop = Color(hex: 0x78986A)
    static let dlBot = Color(hex: 0x819F74)
    static let dwTop = Color(hex: 0xAA7332)
    static let dwBot = Color(hex: 0xB77C36)
    static let tlTop = Color(hex: 0x4B609D)
    static let tlBot = Color(hex: 0x4E66A5)
    static let twTop = Color(hex: 0x713A3C)
    static let twBot = Color(hex: 0x7B4142)
    
    // Placed Bricks
    static let placedTop = Color(hex: 0xE3DFDC)
    static let placedBot = Color(hex: 0xE4E1DC)
    static let newlyPlacedTop = Color(hex: 0xE0D99D)
    static let newlyPlacedBot = Color(hex: 0xE8E29F)
    
    // Empty
    static let emptyTop = Color(hex: 0x282B30)
    static let emptyBot = Color(hex: 0x313339)
    static let board = Color(hex: 0x181A1E)
    
    init(hex: Int) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
