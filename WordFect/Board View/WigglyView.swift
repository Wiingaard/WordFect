//
//  WigglyView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 17/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct WigglyView: View {
    
    @State private var rotation = Angle.degrees(0)
    
    let content: String
    
    var foreverAnimation: Animation {
        Animation.easeOut(duration: 0.25).repeatForever(autoreverses: true)
    }
    
    var body: some View {
        Text(content)
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
struct WigglyView_Previews: PreviewProvider {
    static var previews: some View {
        WigglyView(content: "🤖")
    }
}
