//
//  LineView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct LineView: View {
    
    @State var fields: Line<FieldBrick> = Tray.emptyFields
    
    var onTap: (Int) -> () = { _ in return }
    
    var body: some View {
        HStack {
            ForEach((0..<Tray.size), id: \.self) { index in
                FieldView(
                    field: self.fields[index],
                    onTap: { self.onTap(index) }
                ).aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        let fields = Line([
            FieldBrick.bonus(.dw),
            FieldBrick.cursor(.horizontal),
            FieldBrick.empty,
            FieldBrick.newlyPlaced(PlacedBrick.character(Character("a"))),
            FieldBrick.placed(PlacedBrick.joker(Character("b")))
        ])
        
        return LineView(fields: fields)
            .frame(height: 60)
            .previewLayout(.sizeThatFits)
    }
}
