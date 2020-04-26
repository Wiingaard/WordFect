//
//  LineView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct LineView: View {
    
    @State var fields: [FieldBrick]
    var onTap: (Int) -> () = { _ in return }
    
    var body: some View {
        let bricks = fields.enumerated().map { $0 }
        
        return HStack {
            ForEach(bricks, id: \.offset) { (offset, element) in
                FieldView(field: element, onTap: { self.onTap(offset) })
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        LineView(fields: [
            .placed(.character(Character("a"))),
            .newlyPlaced(.character(Character("b"))),
            .empty,
            .cursor(.vertical),
            .cursor(.horizontal),
            .bonus(.dw)
        ])
    }
}
