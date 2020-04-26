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
            if playingField.isEditing || tray.isEditing {
                Button.init(action: doneAction) {
                    Text("Færdig").bold()
                }.padding()
            } else {
                Button.init(action: playingField.beginEditing) {
                    Text("Rediger").bold()
                }.padding()
            }
        }
    }
    
    private func doneAction() {
        if playingField.isEditing {
            playingField.finishEditing()
        } else {
            tray.finishEditing()
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
