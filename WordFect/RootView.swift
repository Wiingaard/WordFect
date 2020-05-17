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
    
    @ObservedObject var playingField: PlayingField
    @ObservedObject var tray: Tray
    @ObservedObject var keyboard: KeyboardCoordinator
    @ObservedObject var analyze: Analyze
    
    var body: some View {
        NavigationView {
            ZStack {
                PlayingFieldView(playingField: playingField)
                AnalyzeView(analyze: analyze)
                TrayView(tray: tray, keyboard: keyboard)
                Keyboard(isFirstResponder: keyboard.inputEnabled != nil) {
                    self.keyboard.input($0)
                }
            }
            .navigationBarTitle("Rediger")
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: NavigationBarButtons(playingField: playingField, tray: tray) )
            .customNavigationBar(titleColor: UIColor.white, backgroundColor: UIColor.black)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let playingField = PlayingField()
        let tray = Tray()
        return RootView(
            playingField: playingField,
            tray: tray,
            keyboard: KeyboardCoordinator(playingField, tray),
            analyze: Analyze(playingField, tray)
        )
    }
}
