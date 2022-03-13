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
    @ObservedObject var trayVM: TrayViewModel
    
    var body: some View {
        HStack {
            if playingField.isEditing {
                Button.init(action: { self.trayVM.beginEditing() }) {
                    Text("Næste").bold()
                }.padding()
            }
            if trayVM.isEditing {
                Button.init(action: { self.trayVM.finishEditing() }) {
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
        return NavigationBarButtons(playingField: pf, trayVM: TrayViewModel())
            .previewLayout(.sizeThatFits)
    }
}
