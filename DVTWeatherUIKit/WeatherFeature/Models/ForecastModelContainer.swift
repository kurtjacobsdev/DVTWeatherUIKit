//
//  ForecastModelContainer.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

struct ForecastModelContainer: Codable {
    var list: [ForecastModel] = []
    var city: CityModel
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
}
