//
//  ActivityIndicator.swift
//  WordFect
//
//  Created by Martin Wiingaard on 17/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    typealias ViewType = UIActivityIndicatorView
    
    var isAnimating: Bool
    
    var configuration = { (indicator: ViewType) in
        
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> ViewType {
        ViewType()
    }
    
    func updateUIView(_ uiView: ViewType, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}

extension View where Self == ActivityIndicator {
    func configure(_ configuration: @escaping (Self.ViewType)->Void) -> Self {
        Self.init(isAnimating: self.isAnimating, configuration: configuration)
    }
}
