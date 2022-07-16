//
//  TrayTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 13/03/2022.
//  Copyright © 2022 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class TrayTests: XCTestCase {
    
    func testTrayPermutations() {

        let bricks = [
            TrayBrick.character("a"),
            TrayBrick.character("a"),
            TrayBrick.joker
        ]
        
        Tray(bricks: bricks).bricksPermutations
            .map { bricks in
                return bricks.map { $0.character }
            }
            .sorted { $0.count < $1.count }
            .forEach { bricks in
                print(bricks)
            }
        
    }
    
}
