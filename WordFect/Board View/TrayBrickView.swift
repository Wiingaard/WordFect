//
//  TrayBrickView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct TrayBrickView: View {
    
    let trayBrick: TrayBrick?
    
    private var text: String {
        guard let brick = trayBrick else { return "" }
        switch brick {
        case .character(let c): return String(c).uppercased()
        case .joker: return "🤡"
        }
    }
    
    private var scoreText: String {
        guard let brick = trayBrick else { return "" }
        switch brick {
        case .character(let c): return String(Rank.value(for: c))
        case .joker: return ""
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.placedTop, .placedBot]),
                    startPoint: .top,
                    endPoint: .bottom))
                .cornerRadius(4)
            
            Text(text)
                .font(.system(size: 24))
                .bold()
                .foregroundColor(.black)
            
            Text(scoreText)
                .font(.system(size: 14))
                .bold()
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topTrailing)
                .padding(4)
        }
    }
}

struct TrayBrickView_Previews: PreviewProvider {
    static var previews: some View {
        TrayBrickView(trayBrick: .character(Character("a")))
    }
}
