//
//  BoardView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct BoardView: View {
    
    let positions: Matrix<BoardPosition>
    let bricks: Matrix<PlacedBrick?>
    
    static let getRow: (Int, Matrix<BoardPosition>, Matrix<PlacedBrick?>) -> [BoardRowView.Brick] = { (row, positions, bricks) in
            return zip(
            positions[MatrixDirection.horizontal, row],
            bricks[MatrixDirection.horizontal, row]
        ).enumerated().map { (offset, element) -> BoardRowView.Brick in
            .init(
                board: element.0,
                brick: element.1,
                isNew: false,
                position: .init(row: row, column: offset)
            )
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            ForEach((0..<Board.size), id: \.self) { row in
                BoardRowView(
                    bricks: BoardView.getRow(
                        row,
                        self.positions,
                        self.bricks
                    )
                )
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(
            positions: Matrix(Board.standart),
            bricks: TestMap().test()
        ).padding()
            
    }
}
