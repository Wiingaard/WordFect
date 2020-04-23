//
//  PlayingFieldView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 12/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct PlayingFieldView: View {
    
    @ObservedObject var playingField = PlayingField()
    
    @State var isKeyboardActive: Bool = false
    
    var body: some View {
        VStack {
            GridView(fields: self.playingField.fields, onTap: { _ in
                self.playingField.isEditing.toggle()
            })
            Keyboard(isFirstResponder: playingField.isEditing) { keyboardPress in
                print(keyboardPress)
            }
        }
    }
}

struct PlayingFieldView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingFieldView()
    }
}
