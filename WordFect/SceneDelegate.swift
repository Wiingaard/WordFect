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
    let trayVM = TrayViewModel()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = DarkHostingController(rootView: RootView(
                playingField: playingField,
                trayVM: trayVM,
                keyboard: KeyboardCoordinator(playingField, trayVM),
                analyze: Analyze(playingField, trayVM)
            ))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

class DarkHostingController<ContentView> : UIHostingController<ContentView> where ContentView : View {
    override dynamic open var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
