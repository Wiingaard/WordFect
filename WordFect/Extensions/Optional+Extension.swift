//
//  Optional+Extension.swift
//  WordFect
//
//  Created by Martin Wiingaard on 01/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

extension Optional: MatrixDumpable where Wrapped: MatrixDumpable {
    
    var dumpable: String {
        switch self {
        case .none: return "  "
        case .some(let value): return value.dumpable
        }
    }
    
}
