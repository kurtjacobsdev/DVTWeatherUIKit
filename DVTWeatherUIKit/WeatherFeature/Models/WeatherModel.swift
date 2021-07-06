//
//  WeatherModel.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

struct WeatherModel: Decodable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}
