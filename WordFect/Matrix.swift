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
    
    private var grid: Grid
    
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
}

struct MatrixIndex: CustomStringConvertible {
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
    
    var description: String {
        return "(\(row),\(column))"
    }
}
