//
//  Keyboard.swift
//  WordFect
//
//  Created by Martin Wiingaard on 12/04/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

struct Keyboard: View {
    enum Output {
        case delete
        case character(Character)
        case `return`
    }
    
    var isFirstResponder: Bool
    var press: (Keyboard.Output) -> ()
    
    var body: some View {
        _Keyboard(isFirstResponder: isFirstResponder, press: press)
            .frame(width: 0, height: 0)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
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
        if text == "\n" {
            press(.return)
        } else {
            press(.character(character))
        }
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
