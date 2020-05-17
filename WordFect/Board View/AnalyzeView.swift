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
                Text(message)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            )
            
        case .ready:
            return AnyView(
                Button(action: { print("LOL") }) {
                    Text("✨")
                        .font(.system(size: 40))
                        .padding()
                }
                .background(Circle().foregroundColor(.white24))
//                .padding(.vertical, 12)
            )
            
        case .working:
            return AnyView(
                WigglyView(content: "🤖")
            )
            
        case .results(let results):
            return AnyView(
                Text("Results: \(results.count)")
                    .bold()
                    .foregroundColor(.white)
                    .padding()
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
                        self.content().frame(height: 140)
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
