//
//  Matrix.swift
//  WordFect
//
//  Created by Martin Wiingaard on 28/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

class Matrix<T> {
    typealias Field = T
    typealias Line = [T]
    typealias Grid = [[T]]
    
    var grid: Grid
    
    init(_ grid: Grid) {
        self.grid = grid
    }
    
    subscript(index: MatrixIndex) -> Field {
        get { grid[index.row][index.column] }
        set { grid[index.row][index.column] = newValue }
    }
    
    subscript(direction: MatrixDirection, line: Int) -> Line {
        get {
            switch direction {
            case .horizontal: return grid[line]
            case .vertical: return grid.map { $0[line] }
            }
        }
        set {
            switch direction {
            case .horizontal: grid[line] = newValue
            case .vertical: newValue.enumerated().forEach { (index, value) in
                grid[index][line] = value
                }
            }
        }
    }
    
    func map<S>(_ transform: (T) -> S) -> Matrix<S> {
        return Matrix<S>( grid.map { $0.map(transform) } )
    }
    
    func enumerated() -> Matrix<(MatrixIndex, T)> {
        let enumeratedGrid = grid.enumerated().map { (rowIndex, row) in
            row.enumerated().map { (columnIndex, field) in
                return (MatrixIndex.init(row: rowIndex, column: columnIndex), field)
            }
        }
        return Matrix<(MatrixIndex, T)>(enumeratedGrid)
    }
    
    static func forEach(_ body: (MatrixIndex) -> ()) {
        (0..<Board.size).forEach { row in
            (0..<Board.size).forEach { column in
                body(MatrixIndex(row: row, column: column))
            }
        }
    }
}

protocol MatrixDumpable {
    var dumpable: String { get }
}

extension Matrix where T: MatrixDumpable {
    func dump() {
        print(grid.reduce("") { (result, row) -> String in
            return result + row.enumerated().reduce("") { (result, field) -> String in
                if field.offset == 0 {
                    return result + "[\(field.element.dumpable),"
                } else if field.offset == row.count - 1 {
                    return result + "\(field.element.dumpable)]"
                } else {
                    return result + "\(field.element.dumpable),"
                }
            } + "\n"
        })
    }
}

enum MatrixDirection {
    case horizontal
    case vertical
    
    var orthogonal: MatrixDirection {
        switch self {
        case .horizontal: return .vertical
        case .vertical: return .horizontal
        }
    }
}

struct MatrixIndex: CustomStringConvertible, Equatable {
    let row: Int
    let column: Int
    
    func move(_ direction: MatrixDirection, count: Int) -> MatrixIndex {
        switch direction {
        case .horizontal:
            return MatrixIndex(row: row, column: column + count)
        case .vertical:
            return MatrixIndex(row: row + count, column: column)
        }
    }
    
    func moveLine(_ direction: MatrixDirection, _ count: Int, to lineEnd: LineEnd) -> MatrixIndex {
        switch direction {
        case .horizontal:
            return .init(row: lineEnd.lineIndex, column: column + count)
        case .vertical:
            return .init(row: row + count, column: lineEnd.lineIndex)
        }
    }
    
    /// Used to move through the Board. If it reaches a line's end, it will jump to next/previous line begin/end depending on `progress`.
    /// Returns nil on the last/first index of the board
    func iterate(_ progress: Progress, _ direction: MatrixDirection) -> MatrixIndex? {
        let moveField = move(direction, count: progress.unitValue)
        let moveLine = self.moveLine(
            direction.orthogonal,
            progress.unitValue,
            to: progress == .forward ? .begin : .end
        )
        return moveField.isWithinBoard() ? moveField
            : moveLine.isWithinBoard() ? moveLine
            : nil
    }
    
    
    enum Progress {
        case forward
        case backward
        
        var unitValue: Int {
            switch self {
            case .forward: return 1
            case .backward: return -1
            }
        }
    }
    
    enum LineEnd {
        case begin
        case end
        
        var lineIndex: Int {
            switch self {
            case .begin: return 0
            case .end: return Board.size - 1
            }
        }
    }
    
    /// Reads  "Position, how horizontal/vertical are you?"
    /// (row: 0, coloum: 3) results is 0 vertical and 3 horizontal
    /// Rows are vertical and Coloumn are horizontal
    subscript(direction: MatrixDirection) -> Int {
        switch direction {
        case .horizontal: return column
        case .vertical: return row
        }
    }
    
    func isWithinBoard() -> Bool {
        guard row >= 0 && row < Board.size else { return false }
        guard column >= 0 && column < Board.size else { return false }
        return true
    }
    
    var description: String {
        return "(\(row),\(column))"
    }
}
