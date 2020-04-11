//
//  BoardPositionView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 21/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct BoardPositionView: View {
    let board: BoardPosition
    let brick: PlacedBrick?
    let isNewlyPlaces: Bool
    
    private var gradient: Gradient {
        if let brick = brick {
            return isNewlyPlaces
                ? .init(colors: [.newlyPlacedTop, .newlyPlacedBot])
                : brick.gradient
        } else {
            return board.gradient
        }
    }
    
    private var text: String? {
        brick?.text ?? board.text ?? nil
    }
    
    private var scoreText: String? {
        brick?.scoreText ?? nil
    }
    
    private var textColor: Color {
        brick != nil
            ? .black
            : .white
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(gradient: gradient, startPoint: .top, endPoint: .bottom))
                .cornerRadius(12)
            Text(text ?? "")
                .bold()
                .foregroundColor(textColor)
        }.overlay(
            Text(scoreText ?? "")
                .bold()
                .padding(),
            alignment: .topTrailing
        )
    }
}

private extension BoardPosition {
    var gradient: Gradient {
        switch self {
        case .bonus(let bonus):
            switch bonus {
            case .dw: return .init(colors: [.dwTop, .dwBot])
            case .tw: return .init(colors: [.twTop, .twBot])
            case .dl: return .init(colors: [.dlTop, .dlBot])
            case .tl: return .init(colors: [.tlTop, .tlBot])
            }
        case .empty: return .init(colors: [.emptyTop, .emptyBot])
        }
    }
    
    var text: String? {
        switch self {
        case .bonus(let bonus):
            switch bonus {
            case .dw: return "DW"
            case .tw: return "TW"
            case .dl: return "DL"
            case .tl: return "TL"
            }
        case .empty: return nil
        }
    }
}

private extension PlacedBrick {
    
    var gradient: Gradient {
        .init(colors: [.placedTop, .placedBot])
    }
    
    var text: String {
        String(character).uppercased()
    }
    
    var scoreText: String? {
        switch self {
        case .character(let char): return String(Rank.value(for: char))
        case .joker: return nil
        }
    }
}

struct BoardPositionView_Previews: PreviewProvider {
    static var previews: some View {
        BoardPositionView(
            board: .empty,
            brick: .character(Character("a")),
            isNewlyPlaces: false
        )
    }
}
