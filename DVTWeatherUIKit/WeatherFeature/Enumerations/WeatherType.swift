//
//  WeatherType.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import UIKit
import SwiftHEXColors

public enum WeatherType: String, CaseIterable {
    case sunny = "Sunny"
    case cloudy = "Cloudy"
    case rainy = "Rainy"
    
    var title: String {
        return self.rawValue
    }
    
    var color: UIColor? {
        switch self {
        case .cloudy:
            return UIColor(hexString: "#54717a", alpha: 1)
        case .rainy:
            return UIColor(hexString: "#57575d", alpha: 1)
        case .sunny:
            return UIColor(hexString: "#47ab2f", alpha: 1)
        }
    }
    
    var headerImage: UIImage? {
        switch self {
        case .cloudy:
            return UIImage(imageLiteralResourceName: "forest_cloudy.png")
        case .rainy:
            return UIImage(imageLiteralResourceName: "forest_rainy.png")
        case .sunny:
            return UIImage(imageLiteralResourceName: "forest_sunny.png")
        }
    }
    
    var forecastImage: UIImage? {
        switch self {
        case .cloudy:
            return UIImage(named: "cloudy")
        case .rainy:
            return UIImage(named: "rainy")
        case .sunny:
            return UIImage(named: "sunny")
        }
    }

}
