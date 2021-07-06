//
//  CurrentDayViewModel.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

struct CurrentDayViewModel {
    var minTemperature: String
    var currentTemperature: String
    var maxTemperature: String
    var weatherType: WeatherType
    var backgroundColor: UIColor?
}

extension CurrentDayViewModel {
    static func defaultViewModel() -> CurrentDayViewModel {
        return CurrentDayViewModel(minTemperature: "0.0°", currentTemperature: "0.0°", maxTemperature: "0.0°", weatherType: .sunny, backgroundColor: WeatherType.sunny.color)
    }
}

extension CurrentDayViewModel {
    // We make this a failable initialiser - if anything is missing then we just omit the entry and revert to the default (something has gone wrong on the server side, shouldn't be the case though)
    init?(model: CurrentDayModel) {
        guard let id = model.weather.first?.id,
              let weatherType = WeatherCodeFilter.filter(code: id) else { return nil }
        self.currentTemperature = String(format: "%.2f°", model.currentTemperature)
        self.minTemperature = String(format: "%.2f°", model.minTemperature)
        self.maxTemperature = String(format: "%.2f°", model.maxTemperature)
        self.weatherType = weatherType
        self.backgroundColor = self.weatherType.color
    }
}
