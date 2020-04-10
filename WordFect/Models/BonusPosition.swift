//
//  BonusPosition.swift
//  WordFect
//
//  Created by Martin Wiingaard on 21/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

enum BonusPosition {
    case dw
    case tw
    case dl
    case tl
    
    var wordMultiplier: Int {
        switch self {
        case .dl, .tl: return 1
        case .dw: return 2
        case .tw: return 3
        }
    }
    
    var letterMultiplier: Int {
        switch self {
        case .dw, .tw: return 1
        case .dl: return 2
        case .tl: return 3
        }
    }
}
