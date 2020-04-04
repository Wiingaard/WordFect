//
//  BoardPositionView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 21/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct BoardPositionView: View {
    let `type`: BoardPosition
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(type.color)
                .cornerRadius(12)
            Text(type.text ?? "")
                .foregroundColor(.white)
                .bold()
        }
    }
}

private extension BoardPosition {
    var color: Color {
        switch self {
        case .bonus(let bonus):
            switch bonus {
            case .dw: return Color(hex: 0xB67B36)
            case .tw: return Color(hex: 0x794041)
            case .dl: return Color(hex: 0x819F74)
            case .tl: return Color(hex: 0x4D66A4)
            }
        case .empty: return Color.primary
        }
    }
    
    var text: String? {
        switch self {
        case .bonus(let bonus):
            switch bonus {
            case .dw: return "dw"
            case .tw: return "tw"
            case .dl: return "dl"
            case .tl: return "tl"
            }
        case .empty: return nil
        }
    }
}

struct BoardPositionView_Previews: PreviewProvider {
    static var previews: some View {
        BoardPositionView(type: .empty)
    }
}
