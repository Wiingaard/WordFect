//
//  NavigationBarAppearance.swift
//  WordFect
//
//  Created by Martin Wiingaard on 03/05/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import Foundation
import SwiftUI

private struct CustomNavigationBar: ViewModifier {
    
    init(
        titleColor: UIColor,
        backgroundColor: UIColor
    ) {
        UINavigationBar.appearance().backgroundColor = backgroundColor
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: titleColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: titleColor]
    }
    
    func body(content: Content) -> some View {
        content
    }
}

extension View {
    public func customNavigationBar(
        titleColor: UIColor = .black,
        backgroundColor: UIColor = .white
    ) -> some View {
        ModifiedContent(content: self, modifier: CustomNavigationBar(
            titleColor: titleColor,
            backgroundColor: backgroundColor)
        )
    }
}

