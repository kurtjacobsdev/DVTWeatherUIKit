//
//  WeatherCodeFilter.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

/*
  This class exists to map the weather service's weather codes to the reduced scope of sunny, cloudy and rainy. A large number of other types exist (though it is unlikely we would experience certain extremes in South Africa) and this certainly is a extremely lossy mapping. In theory we would support all of the conditions in a full weather application but for the exercise this is a demo app and hopefully is fine.
 */

class WeatherCodeFilter {
    static func filter(code: Int) -> WeatherType? {
        let codeString = String(code)
        guard let first = codeString.first, let last = codeString.last else {
            return nil
        }
        
        switch (first, last) {
        case ("2",_), ("3",_), ("5",_), ("6",_), ("7",_):
            return .rainy
        case ("8","0"):
            return .sunny
        case ("8",_):
            return .cloudy
        default:
            return nil
        }
    }
}
