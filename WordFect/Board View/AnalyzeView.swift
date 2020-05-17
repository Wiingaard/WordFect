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
        case .missingInput:
            return AnyView(
                Text("Missing Input")
             )
            
        case .ready:
            return AnyView(
                WigglyView(content: "🤖")
            )
            
        case .working:
            return AnyView(
                Text("Working")
            )
            
        case .results:
            return AnyView(
                Text("Results")
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
