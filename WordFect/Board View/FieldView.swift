//
//  FieldView.swift
//  WordFect
//
//  Created by Martin Wiingaard on 11/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct FieldView: View {
    
    let field: FieldBrick
    var onTap: () -> () = { return }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: self.field.gradient,
                        startPoint: .top,
                        endPoint: .bottom))
                    .cornerRadius(geometry.size.width / 10)
                
                Text(self.field.centerText)
                    .font(.system(size: geometry.size.height / 2))
                    .bold()
                    .foregroundColor(self.field.textColor)
                    .padding([.trailing], self.field.cornerText.isEmpty ? 0 : geometry.size.width / 20)
                
                Text(self.field.cornerText)
                    .font(.system(size: geometry.size.height / 3))
                    .bold()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topTrailing)
                    .padding(geometry.size.width / 10)
                
                self.field.centerImage?
                    .font(.system(size: geometry.size.width * 0.7, weight: .bold))
            }.onTapGesture { self.onTap() }
        }
    }
}

extension FieldBrick {
    
    var gradient: Gradient {
        switch self {
        case .empty:
            return .init(colors: [.emptyTop, .emptyBot])
        case .bonus(let bonus):
            switch bonus {
            case .dw: return .init(colors: [.dwTop, .dwBot])
            case .tw: return .init(colors: [.twTop, .twBot])
            case .dl: return .init(colors: [.dlTop, .dlBot])
            case .tl: return .init(colors: [.tlTop, .tlBot])
            }
        case .placed, .tray:
            return .init(colors: [.placedTop, .placedBot])
        case .newlyPlaced, .cursor:
            return .init(colors: [.newlyPlacedTop, .newlyPlacedBot])
        case .trayEmpty:
            return .init(colors: [Color(UIColor.systemBackground), Color(UIColor.systemBackground)])
        }
    }
    
    var centerText: String {
        switch self {
        case .empty, .cursor, .trayEmpty: return ""
        case .bonus(let bonus): return bonus.text
        case .placed(let brick): return String(brick.character).uppercased()
        case .newlyPlaced(let brick): return String(brick.character).uppercased()
        case .tray(let brick):
            switch brick {
            case .character(let char): return String(char)
            case .joker: return ""
            }
        }
    }
    
    var cornerText: String {
        switch self {
        case .empty, .bonus, .cursor, .trayEmpty: return ""
        case .placed(let brick), .newlyPlaced(let brick):
            switch brick {
            case .character(let char): return String(Rank.value(for: char))
            case .joker: return ""
            }
        case .tray(let brick):
            switch brick {
            case .character(let char): return String(Rank.value(for: char))
            case .joker: return ""
            }
        }
    }
    
    var centerImage: Image? {
        switch self {
        case .empty, .bonus, .placed, .newlyPlaced, .tray, .trayEmpty:
            return nil
        case .cursor(let direction):
            switch direction {
            case .horizontal: return Image.init(systemName: "arrow.right.square")
            case .vertical: return Image.init(systemName: "arrow.down.square")
            }
        }
    }
    
    var textColor: Color {
        switch self {
        case .bonus: return .white
        default: return .black
        }
    }
}

struct FieldView_Previews: PreviewProvider {
    static let onTap: () -> () = { print("Tap") }
    
    static var previews: some View {
        Group {
            FieldView(
                field: FieldBrick.placed(PlacedBrick.character(Character("a"))), onTap: onTap
            )
            FieldView(field: .empty, onTap: onTap)
            FieldView(field: .cursor(.vertical), onTap: onTap)
        }
    }
}
