//
//  SceneDelegate.swift
//  WordFect
//
//  Created by Martin Wiingaard on 20/03/2020.
//  Copyright © 2020 Wiingaard. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let playingField = PlayingField()
    let tray = Tray()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: RootView(
                playingField: playingField,
                tray: tray,
                keyboard: KeyboardCoordinator(playingField, tray)
            ))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
