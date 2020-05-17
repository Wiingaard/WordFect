//
//  AnalyzeView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 04/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import UIKit


struct AnalyzeView: View {
    
    @ObservedObject var analyze: Analyze
    
    func content() -> AnyView {
        switch analyze.viewState {
        case .missingInput(let message):
            return AnyView(
                Text(message).bold().foregroundColor(.white)
             )
            
        case .ready:
            return AnyView(
                Text("Ready!").bold().foregroundColor(.white)
            )
            
        case .working:
            return AnyView(
                WigglyView(content: "🤖")
            )
            
        case .results(let results):
            return AnyView(
                Text("Results: \(results.count)").bold().foregroundColor(.white)
            )
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Button("Change") {
                    self.analyze.change()
                }
                Spacer()
                VStack {
                    HStack {
                        Spacer()
                        self.content()
                        Spacer()
                    }
                    .padding(.bottom, 72)
                    .padding(.top, 16)
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(Color.white16)
                .cornerRadius(16, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
