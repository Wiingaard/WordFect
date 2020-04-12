//
//  Keyboard.swift
//  WordFect
//
//  Created by Martin Wiingaard on 12/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import UIKit
import SwiftUI

struct Keyboard: View {
    enum Output {
        case delete
        case character(Character)
    }
    
    var isFirstResponder: Bool
    var press: (Keyboard.Output) -> ()
    
    var body: some View {
        _Keyboard(isFirstResponder: isFirstResponder, press: press).frame(maxWidth: 0, maxHeight: 0)
    }
}

fileprivate struct _Keyboard: UIViewRepresentable {
    typealias UIViewType = _UIKeyboardHelperView
    
    var isFirstResponder: Bool
    var press: (Keyboard.Output) -> ()
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
        return _UIKeyboardHelperView(press: press)
    }
    
    func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
        _ = isFirstResponder
            ? uiView.becomeFirstResponder()
            : uiView.resignFirstResponder()
    }
}

fileprivate class _UIKeyboardHelperView: UIView, UIKeyInput {
    var hasText: Bool { true }
    override var canBecomeFirstResponder: Bool { true }
    
    private var press: (Keyboard.Output) -> () = { _ in return }
    
    func insertText(_ text: String) {
        guard let character = text.first else { return }
        press(.character(character))
    }
    
    func deleteBackward() {
        press(.delete)
    }
    
    required init(press: @escaping (Keyboard.Output) -> ()) {
        super.init(frame: .zero)
        self.press = press
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
