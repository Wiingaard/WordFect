//
//  KeyboardCoordinator.swift
//  WordFect
//
//  Created by Martin Wiingaard on 26/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import Combine

class KeyboardCoordinator: ObservableObject {
    
    private var bag = Set<AnyCancellable>()
    
    enum Input {
        case playingField
        case tray
    }
    
    @Published var inputEnabled: Input? = nil
    
    private var playingField: PlayingField
    private var tray: Tray
    
    init(_ playingField: PlayingField, _ tray: Tray) {
        self.playingField = playingField
        self.tray = tray
        
        self.playingField.$isEditing.sink { [weak self] editing in
            if editing {
                self?.tray.finishEditing()
            }
        }.store(in: &bag)
        
        self.tray.$isEditing.sink { [weak self] editing in
            if editing {
                self?.playingField.finishEditing()
            }
        }.store(in: &bag)
        
        Publishers.CombineLatest(self.playingField.$isEditing, self.tray.$isEditing)
            .sink { (editPlayingField, editTray) in
                if editPlayingField {
                    self.inputEnabled = .playingField
                } else if editTray {
                    self.inputEnabled = .tray
                } else {
                    self.inputEnabled = nil
                }
        }.store(in: &bag)
    }
    
    func input(_ input: Keyboard.Output) {
        guard let inputTo = inputEnabled else {
            return
        }
        switch inputTo {
        case .playingField:
            playingField.didInputKey(input)
        case .tray:
            tray.didInputKey(input)
        }
    }
    
}
