//
//  Board.swift
//  WordFect
//
//  Created by Martin Wiingaard on 20/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation

struct Board {
    static let size = 15
    
    static let standart = Matrix<BoardPosition>.Grid([
        [tl, e, e, e,tw, e, e,dl, e, e,tw, e, e, e,tl],
        [ e,dl, e, e, e,tl, e, e, e,tl, e, e, e,dl, e],
        [ e, e,dw, e, e, e,dl, e,dl, e, e, e,dw, e, e],
        [ e, e, e,tl, e, e, e,dw, e, e, e,tl, e, e, e],
        [tw, e, e, e,dw, e,dl, e,dl, e,dw, e, e, e,tw],
        [ e,tl, e, e, e,tl, e, e, e,tl, e, e, e,tl, e],
        [ e, e,dl, e,dl, e, e, e, e, e,dl, e,dl, e, e],
        [dl, e, e,dw, e, e, e, e, e, e, e,dw, e, e,dl],
        [ e, e,dl, e,dl, e, e, e, e, e,dl, e,dl, e, e],
        [ e,tl, e, e, e,tl, e, e, e,tl, e, e, e,tl, e],
        [tw, e, e, e,dw, e,dl, e,dl, e,dw, e, e, e,tw],
        [ e, e, e,tl, e, e, e,dw, e, e, e,tl, e, e, e],
        [ e, e,dw, e, e, e,dl, e,dl, e, e, e,dw, e, e],
        [ e,dl, e, e, e,tl, e, e, e,tl, e, e, e,dl, e],
        [tl, e, e, e,tw, e, e,dl, e, e,tw, e, e, e,tl],
    ])
    
    private static var e: BoardPosition { BoardPosition.empty }
    private static var dl: BoardPosition { BoardPosition.bonus(.dl) }
    private static var tl: BoardPosition { BoardPosition.bonus(.tl) }
    private static var dw: BoardPosition { BoardPosition.bonus(.dw) }
    private static var tw: BoardPosition { BoardPosition.bonus(.tw) }
}


