//
//  KeyboardCoordinator.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import UIKit
import Combine

class KeyboardCoordinator: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    enum Input {
        case playingField
        case tray
    }
    
    @Published var inputEnabled: Input? = nil
    @Published var currentHeight: CGFloat = 0
    @Published var inputAndHeight: (Input?, CGFloat) = (nil, 0)
    
    private var playingField: PlayingField
    private var trayVM: TrayViewModel
    
    init(_ playingField: PlayingField, _ trayVM: TrayViewModel) {
        self.playingField = playingField
        self.trayVM = trayVM
        
        self.playingField.$isEditing.sink { [weak self] editing in
            if editing {
                self?.trayVM.finishEditing()
            }
        }.store(in: &bag)
        
        self.trayVM.$isEditing.sink { [weak self] editing in
            if editing {
                self?.playingField.finishEditing()
            }
        }.store(in: &bag)
        
        Publishers.CombineLatest(self.playingField.$isEditing, self.trayVM.$isEditing)
            .sink { (editPlayingField, editTray) in
                if editPlayingField {
                    self.inputEnabled = .playingField
                } else if editTray {
                    self.inputEnabled = .tray
                } else {
                    self.inputEnabled = nil
                }
        }.store(in: &bag)
        
        Publishers.keyboardHeight
            .assign(to: \.currentHeight, on: self)
            .store(in: &bag)
        
        Publishers.CombineLatest.init($inputEnabled, Publishers.keyboardHeight)
            .assign(to: \.inputAndHeight, on: self)
            .store(in: &bag)
    }
    
    func input(_ input: Keyboard.Output) {
        switch inputEnabled {
        case .none:
            return
        case .playingField:
            playingField.didInputKey(input)
        case .tray:
            trayVM.didInputKey(input)
        }
    }
    
}
