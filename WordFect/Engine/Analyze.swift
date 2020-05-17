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
    private var cancellables: Set<AnyCancellable> = []
    
    private var playingField: PlayingField
    private var tray: Tray
    
    enum ViewState {
        case missingInput(message: String)
        case ready
        case working
        case results(results: [Int])
    }
    
    @Published var viewState: ViewState = .ready
    @Published var isRunning: Bool = false
    
    init(
        _ playingField: PlayingField,
        _ tray: Tray
    ) {
        self.playingField = playingField
        self.tray = tray
        
        missingInputMessage
            .compactMap { $0 }
            .sink { [weak self] message in
//                self?.viewState = .ready
                self?.viewState = .missingInput(message: message)
        }
        .store(in: &cancellables)
        
        Publishers.CombineLatest(canStartRunning, $isRunning)
            .filter { $0.0 && !$0.1 }
            .sink { [weak self] _ in
                self?.viewState = .ready
        }.store(in: &cancellables)
    }
    
    private lazy var missingInputMessage: AnyPublisher = Publishers.CombineLatest(playingField.isEmpty, tray.isEmpty)
        .map { (playingField, tray) -> String? in
            switch (playingField, tray) {
            case (true, _): return "Udfyld spillebræt"
            case (_ , true): return "Udfyld hånd"
            case (false, false): return nil
            }
    }.eraseToAnyPublisher()
    
    private lazy var canStartRunning: AnyPublisher = Publishers.CombineLatest(playingField.isEmpty, tray.isEmpty)
        .map { !$0 && !$1 }
        .eraseToAnyPublisher()
    
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