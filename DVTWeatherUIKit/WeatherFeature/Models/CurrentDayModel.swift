//
//  CurrentDayModel.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

struct CurrentDayModel: Codable {
    var currentTemperature: Double
    var minTemperature: Double
    var maxTemperature: Double
    var weather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
    
    enum MainKeys: String, CodingKey {
        case temp
        case min = "temp_min"
        case max = "temp_max"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let main = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        currentTemperature = (try? main.decode(Double.self, forKey: .temp)) ?? 0
        minTemperature = (try? main.decode(Double.self, forKey: .min)) ?? 0
        maxTemperature = (try? main.decode(Double.self, forKey: .max)) ?? 0
        weather = (try? values.decode([WeatherModel].self, forKey: .weather)) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        // Not Required For Now
    }
}
