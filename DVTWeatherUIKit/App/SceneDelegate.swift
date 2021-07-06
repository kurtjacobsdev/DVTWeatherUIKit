//
//  SceneDelegate.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // We should setup a DI container here instead of having the object instances directly on the SceneDelegate.
    var weatherService: WeatherService!
    var gpsService: GPSService!
    var weatherController: WeatherController!
    var weatherCoordinator: WeatherCoordinator!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       weatherService = WeatherService(session: URLSession.shared)
       gpsService = GPSService()
       weatherController = WeatherController(weatherService: weatherService, gpsService: gpsService)
       weatherCoordinator = WeatherCoordinator(weatherService: weatherService, gpsService: gpsService, weatherController: weatherController)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = weatherCoordinator.navigationController
        weatherCoordinator.begin()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
