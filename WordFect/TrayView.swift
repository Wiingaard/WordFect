//
//  TrayView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import Combine

struct TrayView: View {
    static let defaultTrayPadding: CGFloat = 40
    static let backgroundColor = Color.white24
    
    @ObservedObject var tray: Tray
    @ObservedObject var keyboard: KeyboardCoordinator
    
    @State var trayPadding: CGFloat = TrayView.defaultTrayPadding

    var backgroundView: some View {
        if keyboard.inputEnabled == .tray {
            return Color.black.opacity(0.5).onTapGesture { self.tray.finishEditing() }
        } else {
            return Color.clear.onTapGesture { }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            LineView(fields: self.tray.fields) { self.tray.didTap($0) }
                .padding(10).background(TrayView.backgroundColor).cornerRadius(10)
                .padding(.horizontal, 50)
                .padding(.bottom, trayPadding)
                .onReceive(keyboard.$inputAndHeight) { self.updateTrayHeight($0) }
                .animation(.easeOut(duration: 0.3))
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(backgroundView)
    }
    
    private func updateTrayHeight(_ input: (KeyboardCoordinator.Input?, CGFloat)) {
        switch input.0 {
        case .none, .playingField:
            trayPadding = TrayView.defaultTrayPadding
        case .tray:
            trayPadding = input.1
        }
    }
}
