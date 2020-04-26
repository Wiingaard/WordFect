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
    
    @Published var isActive: Bool = false
    
    private var playingField: PlayingField
    private var tray: Tray
    
    init(_ playingField: PlayingField, _ tray: Tray) {
        self.playingField = playingField
        self.tray = tray
        
        self.playingField.$isEditing.sink { [weak self] editing in
            print("playingField.$isEditing:", editing)
            if editing {
                self?.tray.finishEditing()
            }
        }.store(in: &bag)
        
        self.tray.$isEditing.sink { [weak self] editing in
            print("tray.$isEditing:", editing)
            if editing {
                self?.playingField.finishEditing()
            }
        }.store(in: &bag)
        
        self.tray.$isEditing
            .merge(with: self.playingField.$isEditing)
            .sink { [weak self] isEditing in
                self?.isActive = isEditing
            }.store(in: &bag)
    }
    
    func input(_ input: Keyboard.Output) {
        if playingField.isEditing {
            playingField.didInputKey(input)
        } else if tray.isEditing {
            tray.didInputKey(input)
        }
    }
    
}
