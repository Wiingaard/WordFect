//
//  NavigationBarButtons.swift
//  WordFect
//
//  Created by Martin Wiingaard on 25/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct NavigationBarButtons: View {
    
    @ObservedObject var playingField: PlayingField
    @ObservedObject var tray: Tray
    
    var body: some View {
        HStack {
            if playingField.isEditing {
                Button.init(action: { self.tray.beginEditing() }) {
                    Text("Næste").bold()
                }.padding()
            }
            if tray.isEditing {
                Button.init(action: { self.tray.finishEditing() }) {
                    Text("Færdig").bold()
                }.padding()
            }
        }
    }
}

struct NavigationBarButtons_Previews: PreviewProvider {
    static var previews: some View {
        let pf = PlayingField()
        pf.isEditing = true
        return NavigationBarButtons(playingField: pf, tray: Tray())
            .previewLayout(.sizeThatFits)
    }
}
