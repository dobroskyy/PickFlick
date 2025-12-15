//
//  SceneDelegate.swift
//  PickFlick
//
//  Created by Максим Доброжинский on 17.09.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBar = UITabBarController()
        
        let firstVC = RandomMovieViewController()
        let secondVC = HistoryViewController(networkService: NetworkService())
        
        let navController1 = UINavigationController(rootViewController: firstVC)
        navController1.tabBarItem = UITabBarItem(title: "Рандом", image: nil, tag: 0)
        let navController2 = UINavigationController(rootViewController: secondVC)
        navController2.tabBarItem = UITabBarItem(title: "История", image: nil, tag: 1)
        tabBar.viewControllers = [navController1, navController2]

        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}
