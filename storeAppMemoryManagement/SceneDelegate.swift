//
//  SceneDelegate.swift
//  storeAppMemoryManagement
//
//  Created by Дина Абитова on 18.02.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = TabBarViewController() // Устанавливаем TabBar как главный экран
        window.makeKeyAndVisible()
        
        self.window = window
    }
}
