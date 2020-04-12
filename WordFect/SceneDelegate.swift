//
//  SceneDelegate.swift
//  WordFect
//
//  Created by Martin Wiingaard on 20/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import UIKit
import SwiftUI
import Combinatorics

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let view = PlayingFieldView()
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: view)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
