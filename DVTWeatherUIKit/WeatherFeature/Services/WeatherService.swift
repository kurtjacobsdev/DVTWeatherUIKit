//
//  WeatherService.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation
import CoreLocation

enum OpenWeatherRequest {
    case current(latitude: String, longitude: String, apiKey: String)
    case forecast(latitude: String, longitude: String, apiKey: String)
}

enum OpenWeatherServiceError: Error {
    case dataParsingError
    case jsonDecodingError
    case networkError
    case requestFailureError
}

class OpenWeatherURL {
    static func create(request: OpenWeatherRequest) -> URL {
        switch request {
        case let .current(latitude, longitude, key):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/weather"
            components.queryItems = [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "appid", value: key),
                URLQueryItem(name: "units", value: "metric")
            ]
            return components.url!
        case let .forecast(latitude, longitude, key):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.openweathermap.org"
            components.path = "/data/2.5/forecast"
            components.queryItems = [
                URLQueryItem(name: "lat", value: latitude),
                URLQueryItem(name: "lon", value: longitude),
                URLQueryItem(name: "appid", value: key),
                URLQueryItem(name: "units", value: "metric")
            ]
            return components.url!
        }
    }
}

class WeatherService {
    // We can secure this key somewhere safe such as in the application binary using a block cipher and load it at runtime but for a demo application I think this is okay.
    private static var apiKey = "b833cc84a378af044faafb0bada0ab3f"

    private var session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    private func current(at location: CLLocation, complete: @escaping (Result<CurrentDayModel, OpenWeatherServiceError>) -> ()) {
        session.dataTask(with: OpenWeatherURL.create(request: .current(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), apiKey: WeatherService.apiKey))) { (data, response, error) in
            if let _ = error {
                complete(.failure(.networkError))
                return
            }
            guard let data = data else {
                complete(.failure(.dataParsingError))
                return
            }
            guard let model = try? JSONDecoder().decode(CurrentDayModel.self, from: data) else {
                complete(.failure(.jsonDecodingError))
                return
            }
            complete(.success(model))
        }.resume()
    }
    
    private func forecast(at location: CLLocation, complete: @escaping (Result<ForecastModelContainer, OpenWeatherServiceError>) -> ()) {
        session.dataTask(with: OpenWeatherURL.create(request: .forecast(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), apiKey: WeatherService.apiKey))) { (data, response, error) in
            if let _ = error {
                complete(.failure(.networkError))
                return
            }
            guard let data = data else {
                complete(.failure(.dataParsingError))
                return
            }
            guard var model = try? ForecastModelContainer.decoder.decode(ForecastModelContainer.self, from: data) else {
                complete(.failure(.jsonDecodingError))
                return
            }
            let filtered = WeatherDateAverageFilter.filter(models: model.list)
            model.list = filtered
            complete(.success(model))
        }.resume()
    }
    
    func getWeather(at location: CLLocation, complete: @escaping (Result<(CurrentDayModel?, ForecastModelContainer?), OpenWeatherServiceError>) -> ()) {
        let dispatchGroup = DispatchGroup()
        
        var currentModel: CurrentDayModel?
        var forecastModelContainer: ForecastModelContainer?
        
        dispatchGroup.enter()
        current(at: location) { model in
            switch model {
            case let .success(model):
                currentModel = model
            default:
                break
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        forecast(at: location) { model in
            switch model {
            case let .success(model):
                forecastModelContainer = model
            default:
                break
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            guard let _ = currentModel, let _ = forecastModelContainer else {
                complete(.failure(.requestFailureError))
                return
            }
            complete(.success((currentModel, forecastModelContainer)))
        }
    }
}
