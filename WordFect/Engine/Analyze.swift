//
//  Analyze.swift
//  WordFect
//
//  Created by Martin Wiingaard on 17/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import Combine

class Analyze: ObservableObject {
    private var playingField: PlayingField
    private var tray: Tray
    
    enum ViewState {
        case missingInput(message: String)
        case ready
        case working
        case results(results: [Int])
    }
    
    @Published var viewState: ViewState = .ready
    
    init(
        _ playingField: PlayingField,
        _ tray: Tray
    ) {
        self.playingField = playingField
        self.tray = tray
    }
    
    func change() {
        objectWillChange.send()
        
        switch viewState {
        case .missingInput: viewState = .ready
        case .ready: viewState = .working
        case .working: viewState = .results(results: [1,2,3])
        case .results: viewState = .missingInput(message: "OMG")
        }
    }
    
}
