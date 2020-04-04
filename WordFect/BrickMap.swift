//
//  BrickMap.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
    
private let emptyRow = Matrix<PlacedBrick?>.Line(repeating: nil, count: Board.size)
private let emptyMap = Matrix<PlacedBrick?>.Grid.init(repeating: emptyRow, count: Board.size)

private func emptyRows(_ count: Int) -> [[PlacedBrick?]] {
    return Array.init(repeating: emptyRow, count: count)
}
private func word(_ string: String) -> [PlacedBrick] {
    return string.map(PlacedBrick.character)
}
private func lineOf(_ brick: PlacedBrick?, length: Int) -> [PlacedBrick?] {
    return Array.init(repeating: brick, count: length)
}

struct TestMap {
    static let empty = emptyMap
}

struct TestLine {
    static let cat = [nil,nil] + word("cat") + lineOf(nil, length: 10)
    static let martin = lineOf(nil, length: 3) + word("martin") + lineOf(nil, length: 6)
}
