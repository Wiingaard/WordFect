//
//  RootView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 18/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import KeyboardAvoidance

struct RootView: View {
    
    let playingField = PlayingField()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    PlayingFieldView(playingField: playingField)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    Text("Hello from bottom")
                }
            }
            .animation(nil)
            .navigationBarTitle(Text("WordFect"))
            .navigationBarItems(trailing: NavigationBarButtons(playingField: playingField))
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
