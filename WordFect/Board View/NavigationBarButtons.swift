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
    
    var body: some View {
        HStack {
            if playingField.isEditing {
                Button.init(action: playingField.finishEditing) {
                    Text("Færdig").bold()
                }.padding()
            } else {
                Button.init(action: playingField.beginEditing) {
                    Text("Rediger").bold()
                }.padding()
            }
        }
    }
}

struct NavigationBarButtons_Previews: PreviewProvider {
    static var previews: some View {
        let pf = PlayingField()
        pf.isEditing = true
        return NavigationBarButtons(playingField: pf)
            .previewLayout(.sizeThatFits)
    }
}
