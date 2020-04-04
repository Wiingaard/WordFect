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
        
        let playingField2 = PlayingField(bricks: TestMap.empty)
        playingField2.bricks[.horizontal, 1] = TestLine.cat
        playingField2.bricks[.vertical, 6] = TestLine.martin
        playingField2.bricks[MatrixIndex(row: 1, column: 6)] = PlacedBrick.character("h")
        playingField2.bricks.dump()
        
        print("All in:", Permutation(of: [1,2,1,2,3], size: 3).count)
        
        print("Insert 1:", Permutation(of: [1,2,1], size: 3).count)
        print("Insert 2:", Permutation(of: [1,2,2], size: 3).count)
        print("Insert 3:", Permutation(of: [1,2,3], size: 3).count)
        
//        Permutation(of: "swift").forEach { print($0) }
        
        let joker = "123"
//        ProductSet(tray, joker).forEach { print($0) }
        
//        Combination(of: joker, size: 2).forEach { print($0) }
//        Permutation(of: joker, size: 4).forEach { print($0) }
//        ProductSet([joker, joker]).forEach { print($0) }
//        CartesianProduct.init(joker, joker).forEach { print($0) }
//        PowerSet(of: joker, size: 2).forEach { print($0) }
//        BaseN(of: joker, size: 3).forEach { print($0) }
        
//        BaseN(of: joker, size: 1).forEach { print($0) }
        
//        let tray = [TrayBrick.joker, TrayBrick.joker]
//
//        playingField.permutationSets(tray: tray).forEach { bricks in
//            print(bricks)
//        }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

