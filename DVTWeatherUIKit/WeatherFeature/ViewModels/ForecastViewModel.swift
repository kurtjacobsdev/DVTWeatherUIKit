//
//  ForecastViewModel.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit

struct ForecastViewModel {
    var day: String
    var temperature: String
    var image: UIImage?
    var weatherType: WeatherType
    var backgroundColor: UIColor?
    
    //One would usually have this in a custom foundation formatter or in a formatter provider class but as a single case it might be a candidate for future refactoring.
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }
}

extension ForecastViewModel {
    // We make this a failable initialiser - if anything is missing then we just omit the entry and revert to the default (something has gone wrong on the server side, shouldn't be the case though)
    init?(model: ForecastModel, backgroundColor: UIColor?, timezone: Int) {
        guard let id = model.weather.first?.id,
              let weatherType = WeatherCodeFilter.filter(code: id),
              let date = model.date else { return nil }
        ForecastViewModel.dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        self.day = ForecastViewModel.dateFormatter.string(from: date)
        self.temperature = String(format: "%.2f°", model.temperature)
        self.weatherType = weatherType
        self.backgroundColor = backgroundColor
        self.image = self.weatherType.forecastImage
    }
}
