//
//  TrayView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct TrayView: View {
    
    let tray: Tray

    private var empties: Int { 7 - tray.count }
    
    private var bricks: [TrayBrick?] {
        tray + Array<TrayBrick?>(repeating: nil, count: empties)
    }
    
    var body: some View {
        HStack {
            ForEach((0..<7), id: \.self) { index in
                TrayBrickView(trayBrick: self.bricks[index])
                    .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

struct TrayView_Previews: PreviewProvider {
    static var previews: some View {
        TrayView(tray: [
            .character(Character("a")),
            .character(Character("c")),
            .character(Character("d")),
            .joker,
            .character(Character("e"))
        ])
    }
}
