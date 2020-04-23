//
//  GridView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct GridView: View {
    
    @State var fields: Matrix<FieldBrick> = PlayingField.empty
    
    var onTap: (MatrixIndex) -> () = { _ in return }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
            ForEach((0..<Board.size), id: \.self) { row in
                HStack(alignment: .center, spacing: 2) {
                    ForEach((0..<Board.size), id: \.self) { column in
                        FieldView(
                            field: self.fields[MatrixIndex(row: row, column: column)],
                            onTap: { self.onTap(MatrixIndex(row: row, column: column)) }
                        )
                    }
                }
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

struct GridView_Previews: PreviewProvider {
    
    static var previews: some View {
        GridView(fields: PlayingField.empty)
    }
}
