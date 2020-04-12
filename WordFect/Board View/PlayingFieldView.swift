//
//  PlayingFieldView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 12/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct PlayingFieldView: View {
    @State var isKeyboardActive: Bool = false
    
    var body: some View {
        VStack {
            GridView(fields: GridView.testField, onTap: { _ in
                self.isKeyboardActive.toggle()
            })
            Keyboard(isFirstResponder: isKeyboardActive) { keyboardPress in
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
