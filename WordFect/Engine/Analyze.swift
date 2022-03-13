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
    private var trayVM: TrayViewModel
    
    enum ViewState {
        case missingInput(message: String)
        case ready
        case working
        case results(results: [Int])
    }
    
    @Published var viewState: ViewState = .ready
    @Published var isRunning: Bool = false
    var workingFields: Matrix<Bool> = .all(false)
    
    init(
        _ playingField: PlayingField,
        _ trayVM: TrayViewModel
    ) {
        self.playingField = playingField
        self.trayVM = trayVM
        
        missingInputMessage
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.viewState = .ready
//                self?.viewState = .missingInput(message: message)
        }
        .store(in: &cancellables)
        
        Publishers.CombineLatest(canStartRunning, $isRunning)
            .filter { $0.0 && !$0.1 }
            .sink { [weak self] _ in
                self?.viewState = .ready
        }.store(in: &cancellables)
    }
    
    private lazy var missingInputMessage: AnyPublisher = Publishers.CombineLatest(playingField.isEmpty, trayVM.isEmpty)
        .map { (playingField, tray) -> String? in
            switch (playingField, tray) {
            case (true, _): return "Udfyld spillebræt"
            case (_ , true): return "Udfyld hånd"
            case (false, false): return nil
            }
    }.eraseToAnyPublisher()
    
    private lazy var canStartRunning: AnyPublisher = Publishers.CombineLatest(playingField.isEmpty, trayVM.isEmpty)
        .map { !$0 && !$1 }
        .eraseToAnyPublisher()
    
    func start() {
        viewState = .working
        Matrix<Void>.forEach { index in
            workingFields[index] = true
            let random = Double.random(in: 1...4)
            let delay = RunLoop.SchedulerTimeType.Stride(TimeInterval(random))
            Just(false)
                .delay(for: delay, scheduler: RunLoop.main)
                .sink { [weak self] isWorking in
                    self?.workingFields[index] = isWorking
            }.store(in: &cancellables)
        }
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
