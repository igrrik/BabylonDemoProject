//
//  SceneDelegate.swift
//  BabylonDemoProject
//
//  Created by Igor Kokoev on 11.06.2020.
//  Copyright © 2020 Igor Kokoev. All rights reserved.
//
//  swiftlint:disable all

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let appModuleFactory = ApplicationModuleFactory()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = appModuleFactory.makePhotosListModule()
        window?.makeKeyAndVisible()
    }
}
