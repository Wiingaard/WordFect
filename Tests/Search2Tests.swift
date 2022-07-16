//
//  Search2Tests.swift
//  Tests
//
//  Created by Martin Wiingaard on 13/03/2022.
//  Copyright © 2022 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class Search2Tests: XCTestCase {
    
    func testNewSearch() {
        let position = MatrixIndex(row: 0, column: 0)
        let tray = [
            TrayBrick.character("a"),
            TrayBrick.character("b"),
            TrayBrick.character("c"),
        ]
        let bricks = makeBricks()
        let search = Search2(
            position: position,
            direction: .horizontal,
            tray: tray,
            bricks: bricks
        )
        
    }
    
}

func printSearch(_ search: Search.DirectionSearch) {
    print("Search (\(search.results.count)):", search.origin, search.direction)
    search.results.forEach { result in
        print(result.map { $0.dumpable })
    }
}
