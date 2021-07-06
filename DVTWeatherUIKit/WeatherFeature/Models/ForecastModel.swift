//
//  ForecastModel.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

struct ForecastModel: Codable {
    var date: Date?
    var temperature: Double
    var weather: [WeatherModel]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case weather
        case main
    }
    
    enum MainKeys: String, CodingKey {
        case temp
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let main = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        date = (try? values.decode(Date.self, forKey: .date))
        temperature = (try? main.decode(Double.self, forKey: .temp)) ?? 0
        weather = (try? values.decode([WeatherModel].self, forKey: .weather)) ?? []
    }
    
    func encode(to encoder: Encoder) throws {
        // Not Required For Now
    }
}
