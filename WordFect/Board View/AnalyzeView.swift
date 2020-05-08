//
//  AnalyzeView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 04/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI
import UIKit

struct RobotView: View {
    @State var rotation = Angle(degrees: 0)
    let size: CGFloat
    
    var body: some View {
        return ZStack {
            Circle()
                .foregroundColor(Color.white24)
                .frame(width: self.size, height: self.size)
            Text("🤖")
                .font(.system(size: self.size / 2))
                .rotationEffect(self.rotation)
                .onAppear {
                    self.rotation = Angle.init(degrees: -10)
                    withAnimation(Animation.easeOut(duration: 0.2).repeatForever(autoreverses: true)) {
                        self.rotation = Angle(degrees: 10)
                    }
                }
        }
    }
}

struct AnalyzeView: View {
    @State var size: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button.init(action: {
                        self.size = self.size == 80 ? 40 : 80
                    }, label: { Text("Change size").foregroundColor(Color.blue) })
                    RobotView(size: self.size).padding(32)
                    Spacer()
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(Color.white16)
                .cornerRadius(16, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct AnalyzeView_Previews: PreviewProvider {
    static var previews: some View {
        AnalyzeView()
    }
}
