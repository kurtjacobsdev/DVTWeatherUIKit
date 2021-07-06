//
//  WeatherController.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation
import CoreLocation

class WeatherController {
    private (set) var forecast: [ForecastViewModel] = []
    private (set) var current: CurrentDayViewModel = CurrentDayViewModel.defaultViewModel()
    
    private var weatherService: WeatherService
    private var gpsService: GPSServiceProtocol
    
    var weatherDidUpdate: ObserverSet<Bool> = ObserverSet<Bool>()
    
    init(weatherService: WeatherService, gpsService: GPSServiceProtocol) {
        self.weatherService = weatherService
        self.gpsService = gpsService
        addObservables()
    }
    
    private func addObservables() {
        gpsService.locationDidUpdateObservable.add { [weak self] auth, location in
            guard let location = location else { return }
            self?.fetchWeather(at: location) { success in
                self?.weatherDidUpdate.notify(success)
            }
        }
    }
    
    // MARK: - Weather
    
    private func fetchWeather(at location: CLLocation, complete: @escaping (Bool) -> ()) {
        weatherService.getWeather(at: location) { [weak self] result in
            switch result {
            case let .success((current, forecast)):
                guard let current = current,
                      let forecast = forecast,
                      let currentViewModel = CurrentDayViewModel.init(model: current) else {
                    self?.current = CurrentDayViewModel.defaultViewModel()
                    self?.forecast = []
                    complete(true)
                    return
                }
                
                self?.current = currentViewModel
                self?.forecast = forecast.list.compactMap {
                    ForecastViewModel(model: $0, backgroundColor: currentViewModel.backgroundColor, timezone: forecast.city.timezone)
                }
                complete(true)
            case .failure(_):
                complete(false)
            }
        }
    }
    
    // MARK: - GPS
    
    func shouldPresentGPSOverlay() -> Bool {
        switch gpsService.locationStatus {
        case .denied, .notDetermined:
            return true
        default:
            return false
        }
    }
    
    func refresh() {
        gpsService.refreshLocation()
    }
}
