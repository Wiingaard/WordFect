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
    
    @ObservedObject var tray: Tray
    @ObservedObject var keyboard: KeyboardCoordinator
    
    @State var trayPadding: CGFloat = TrayView.defaultTrayPadding

    var body: some View {
        VStack {
            Spacer()
            LineView(fields: self.tray.fields) { self.tray.didTap($0) }
                .frame(height: 60)
                .background(Color.gray)
                .padding(.bottom, trayPadding)
                .onReceive(Publishers.keyboardHeight) { self.updateTrayPadding($0) }
                .animation(.easeOut(duration: 0.3))
                .onReceive(keyboard.$inputEnabled) { self.returnTrayIfNeeded($0) }
        }.edgesIgnoringSafeArea(.bottom)
    }
    
    private func updateTrayPadding(_ keyboardHeight: CGFloat) {
        trayPadding = tray.isEditing
            ? keyboardHeight
            : TrayView.defaultTrayPadding
    }
    
    private func returnTrayIfNeeded(_ input: KeyboardCoordinator.Input?) {
        guard let input = input, input == .playingField else { return }
        trayPadding = TrayView.defaultTrayPadding
    }
}

//struct TrayView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrayView(tray: Tray(), keyboard: KeyboardCoordinator())
//    }
//}
