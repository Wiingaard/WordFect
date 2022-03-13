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
    @ObservedObject var trayVM: TrayViewModel
    @ObservedObject var keyboard: KeyboardCoordinator
    @ObservedObject var analyze: Analyze
    
    var body: some View {
        NavigationView {
            ZStack {
                PlayingFieldView(playingField: playingField, analyze: analyze)
                AnalyzeView(analyze: analyze)
                TrayView(vm: trayVM, keyboard: keyboard)
                Keyboard(isFirstResponder: keyboard.inputEnabled != nil) {
                    self.keyboard.input($0)
                }
            }
            .navigationBarTitle("Rediger")
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationBarItems(trailing: NavigationBarButtons(
                playingField: playingField,
                trayVM: trayVM)
            )
            .customNavigationBar(titleColor: UIColor.white, backgroundColor: UIColor.black)
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let playingField = PlayingField()
        let trayVM = TrayViewModel()
        return RootView(
            playingField: playingField,
            trayVM: trayVM,
            keyboard: KeyboardCoordinator(playingField, trayVM),
            analyze: Analyze(playingField, trayVM)
        )
    }
}
