//
//  AnalyzeView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 04/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import UIKit

struct WigglyRobotView: View {
    
    @State private var rotation = Angle.degrees(0)
    
    var foreverAnimation: Animation {
        Animation.easeOut(duration: 0.25).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        Text("🤖")
            .font(.system(size: 60))
            .rotationEffect(self.rotation)
            .onAppear {
                self.rotation = .degrees(-10)
                withAnimation(self.foreverAnimation) {
                    self.rotation = .degrees(10)
                }
        }
        .padding()
        .background(Circle().foregroundColor(.white24))
    }
}


struct AnalyzeView: View {
    
    enum ViewState {
        case missingInput(message: String)
        case ready
        case working
        case results(results: [Int])
    }
    
    @State private var viewState: ViewState = .ready

    func content() -> AnyView {
        switch viewState {
        case .missingInput:
            return AnyView(
                Text("Missing Input")
             )
            
        case .ready:
            return AnyView(
                WigglyRobotView()
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
    
    func change() {
        switch viewState {
        case .missingInput: viewState = .ready
        case .ready: viewState = .working
        case .working: viewState = .results(results: [1,2,3])
        case .results: viewState = .missingInput(message: "OMG")
        }
    }
}

struct AnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
        WigglyRobotView().previewLayout(.sizeThatFits)
    }
}
