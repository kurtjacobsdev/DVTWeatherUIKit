//
//  WeatherCoordinator.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

protocol WeatherViewControllerCoordinatorDelegate: NSObjectProtocol {
    func presentGPSOverlay()
}

class WeatherCoordinator: NSObject, WeatherViewControllerCoordinatorDelegate {
    var navigationController: UINavigationController = UINavigationController()
    
    var weatherService: WeatherService
    var gpsService: GPSService
    var weatherController: WeatherController
    
    init(weatherService: WeatherService, gpsService: GPSService, weatherController: WeatherController) {
        self.weatherService = weatherService
        self.gpsService = gpsService
        self.weatherController = weatherController
        super.init()
    }
    
    // MARK: - Actions
    
    func begin() {
        let viewController = WeatherViewController(weatherController:self.weatherController)
        viewController.coordinatorDelegate = self
        navigationController.viewControllers = [viewController]
    }
    
    func presentGPSOverlay() {
        // A UseCase / Interactor / Controller should be here for the service but feels a bit overkill for now -- future refactoring candidate
        let gpsOverlay = GPSRequestViewController(service: gpsService)
        gpsOverlay.modalPresentationStyle = .fullScreen
        self.navigationController.present(gpsOverlay, animated: false, completion: nil)
    }
}
