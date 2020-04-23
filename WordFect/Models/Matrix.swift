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

struct MatrixIterator<T>: IteratorProtocol {
    var index = MatrixIndex.init(row: 0, column: 0)
    private let max = Board.size - 1
    private let matrix: Matrix<T>
    
    init(_ matrix: Matrix<T>) {
        self.matrix = matrix
    }
    
    mutating func next() -> T? {
        guard index.column < max || index.row < max else { return nil }
        
        if index.column == max {
            index = .init(row: index.row + 1, column: 0)
        } else {
            index = .init(row: index.row, column: index.column + 1)
        }
        
        return matrix[index]
    }
}
