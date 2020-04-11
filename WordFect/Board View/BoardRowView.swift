//
//  BoardRowView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct BoardRowView: View {
    
    struct Brick: Identifiable {
        let board: BoardPosition
        let brick: PlacedBrick?
        let isNew: Bool
        let position: MatrixIndex
        var id: String {
            position.description
        }
    }
    
    let bricks: [Brick]
    
    var body: some View {
        HStack(alignment: .center, spacing: 1) {
            ForEach(bricks) { brick -> BoardPositionView in
                BoardPositionView(
                    board: brick.board,
                    brick: brick.brick,
                    isNewlyPlaces: brick.isNew
                )
            }
        }
    }
}

struct BoardRowView_Previews: PreviewProvider {
    static let bricks: [BoardRowView.Brick] = [
        .init(
            board: .empty,
            brick: .character(Character("a")),
            isNew: false,
            position: .init(row: 0, column: 1)
        ),
        .init(
            board: .empty,
            brick: .character(Character("b")),
            isNew: false,
            position: .init(row: 0, column: 2)
        ),
        .init(
            board: .empty,
            brick: .character(Character("c")),
            isNew: false,
            position: .init(row: 0, column: 3)
        )
    ]
    
    static var previews: some View {
        BoardRowView(bricks: bricks)
    }
}
