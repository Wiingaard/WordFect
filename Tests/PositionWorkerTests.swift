//
//  PositionWorkerTests.swift
//  Tests
//
//  Created by Martin Wiingaard on 10/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import XCTest
@testable import WordFect

class PositionWorkerTests: XCTestCase {
    
    /// catz: 8+1+2+(9*3) = 38
    /// zap: (9*3)+1+4 = 32
    /// pm: 4+4 = 8
    /// total: 38+32+8=74
    func testWorker() {
        let testMap = makeBricks()
        testMap.dump()
        let testBoard = makeBoard()
        testBoard.dump()
        let testList = makeList(withExtra: ["catz", "zap", "pm"])
        let testTray = makeTray("apz")
        
        let worker = PositionWorker(
            position: .init(row: 1, column: 5),
            list: testList,
            bricks: testMap,
            board: testBoard,
            tray: testTray
        )
        let workerResults = worker.analyze()
        
        assert(workerResults.count == 1)
        
        let controlNewlyPlaced: [FixedBrick] = [
            .init(brick: .character("z"), index: 0),
            .init(brick: .character("a"), index: 1),
            .init(brick: .character("p"), index: 2)
        ]
        
        let controlResult = Rank.RankedResult(
            word: makeWord("zap"),
            newlyPlaced: controlNewlyPlaced,
            score: 78,
            direction: .vertical,
            position: .init(row: 1, column: 5)
        )
        
        assert(workerResults.contains(controlResult))
    }

}
