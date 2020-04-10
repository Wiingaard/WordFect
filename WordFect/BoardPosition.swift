//
//  BoardPosition.swift
//  WordFect
//
//  Created by Martin Wiingaard on 21/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

enum BoardPosition: MatrixDumpable {
    case empty
    case bonus(BonusPosition)
    
    var wordMultiplier: Int {
        switch self {
        case .empty: return 1
        case .bonus(let bonus): return bonus.wordMultiplier
        }
    }
    
    var letterMultiplier: Int {
        switch self {
        case .empty: return 1
        case .bonus(let bonus): return bonus.letterMultiplier
        }
    }
    
    var dumpable: String {
        switch self {
        case .empty: return "  "
        case .bonus(let bonus):
            switch bonus {
            case .dl: return "dl"
            case .dw: return "dw"
            case .tl: return "tl"
            case .tw: return "tw"
            }
        }
    }
}
