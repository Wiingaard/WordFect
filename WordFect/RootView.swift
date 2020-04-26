//
//  RootView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 18/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import Combine

struct RootView: View {
    
    static let defaultTrayPadding: CGFloat = 40
    
    @ObservedObject var playingField: PlayingField
    @ObservedObject var tray: Tray
    @ObservedObject var keyboard: KeyboardCoordinator
    
    @State var trayPadding: CGFloat = RootView.defaultTrayPadding
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    PlayingFieldView(playingField: playingField)
                    Spacer()
                }
                VStack {
                    Spacer()
                    TrayView(tray: tray)
                        .background(Color.gray)
                        .padding(.bottom, trayPadding)
                        .onReceive(Publishers.keyboardHeight) { self.updateTrayPadding($0) }
                        .animation(.easeOut(duration: 0.3))
                        .onReceive(playingField.$isEditing) { editing in
                            if editing {
                                self.updateTrayPadding(0)
                            }
                    }
                }.edgesIgnoringSafeArea(.bottom)
                Keyboard(isFirstResponder: keyboard.isActive) {
                    self.keyboard.input($0)
                }
            }
            .animation(nil)
            .navigationBarTitle(Text("WordFect"))
            .navigationBarItems(trailing: NavigationBarButtons(playingField: playingField, tray: tray))
        }
    }
    
    private func updateTrayPadding(_ keyboardHeight: CGFloat) {
        trayPadding = tray.isEditing ? keyboardHeight : RootView.defaultTrayPadding
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let playingField = PlayingField()
        let tray = Tray()
        return RootView(
            playingField: playingField,
            tray: tray,
            keyboard: KeyboardCoordinator(playingField, tray)
        )
    }
}
