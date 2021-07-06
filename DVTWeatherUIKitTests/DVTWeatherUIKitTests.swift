//
//  DVTWeatherUIKitTests.swift
//  DVTWeatherUIKitTests
//
//  Created by Kurt Jacobs
//

import XCTest
@testable import DVTWeatherUIKit
import SwiftHEXColors
import CoreLocation

class DVTWeatherUIKitTests: XCTestCase {
    
    // Network Request Tests
    
    func testNetworkURLConstruction() throws {
        XCTAssertNotNil(OpenWeatherURL.create(request: .current(latitude: "2", longitude: "2", apiKey: "123")))
        XCTAssertNotNil(OpenWeatherURL.create(request: .forecast(latitude: "2", longitude: "2", apiKey: "123")))
    }

    // Enumeration Tests
    
    func testWeatherTypeVariables() throws {
        for weatherType in WeatherType.allCases {
            XCTAssertNotNil(weatherType.color, "There are some invalid colors")
            XCTAssertNotNil(weatherType.headerImage, "There are some invalid header images")
            XCTAssertNotNil(weatherType.forecastImage, "There are some forecast day images")
        }
    }

    // Model Tests
    
    func testCurrentDayModelJSON() throws {
        let data = try DVTWeatherUIKitTests.load(file: "weather")
        let model = try JSONDecoder().decode(CurrentDayModel.self, from: data)
        
        XCTAssertEqual(model.currentTemperature, 37.93)
        XCTAssertEqual(model.maxTemperature, 37.93)
        XCTAssertEqual(model.minTemperature, 37.93)
        XCTAssertEqual(model.weather.first?.id, 803)
        XCTAssertEqual(model.weather.first?.main, "Clouds")
        XCTAssertEqual(model.weather.first?.description, "broken clouds")
        XCTAssertEqual(model.weather.first?.icon, "04d")
    }
    
    func testForecastModelJSON() throws {
        let data = try DVTWeatherUIKitTests.load(file: "forecast")
        let model = try ForecastModelContainer.decoder.decode(ForecastModelContainer.self, from: data)
        XCTAssertEqual(model.city.timezone, 7200)
        
        let firstForecast = model.list.first
        XCTAssertEqual(firstForecast?.temperature, 37.93)
        XCTAssertEqual(firstForecast?.date?.timeIntervalSinceReferenceDate, 647190000.0)
        XCTAssertEqual(firstForecast?.weather.first?.id, 803)
        XCTAssertEqual(firstForecast?.weather.first?.main, "Clouds")
        XCTAssertEqual(firstForecast?.weather.first?.description, "broken clouds")
        XCTAssertEqual(firstForecast?.weather.first?.icon, "04d")
    }
    
    // View Model Tests
    
    func testCurrentViewModel() throws {
        let data = try DVTWeatherUIKitTests.load(file: "weather")
        let model = try JSONDecoder().decode(CurrentDayModel.self, from: data)
        let viewModel = CurrentDayViewModel(model: model)
        
        XCTAssertEqual(viewModel?.currentTemperature, "37.93°")
        XCTAssertEqual(viewModel?.maxTemperature, "37.93°")
        XCTAssertEqual(viewModel?.minTemperature, "37.93°")
        XCTAssertEqual(viewModel?.backgroundColor, WeatherType.cloudy.color)
        XCTAssertEqual(viewModel?.weatherType, .cloudy)
    }
    
    func testForecastViewModel() throws {
        let data = try DVTWeatherUIKitTests.load(file: "forecast")
        let model = try ForecastModelContainer.decoder.decode(ForecastModelContainer.self, from: data)
        let viewModels = model.list.compactMap {
            ForecastViewModel(model: $0, backgroundColor: WeatherType.cloudy.color, timezone: model.city.timezone)
        }
        let firstForecastViewModel = viewModels.first
        XCTAssertEqual(firstForecastViewModel?.temperature, "37.93°")
        XCTAssertEqual(firstForecastViewModel?.day, "Monday")
        XCTAssertEqual(firstForecastViewModel?.weatherType, .cloudy)
        XCTAssertEqual(firstForecastViewModel?.image, WeatherType.cloudy.forecastImage)
        XCTAssertEqual(firstForecastViewModel?.backgroundColor, WeatherType.cloudy.color)
    }
    
    // Filter Tests
    
    func testWeatherCodeFilter() throws {
        let expectations = [
            (code: 800, weatherType: WeatherType.sunny),
            (code: 801, weatherType: WeatherType.cloudy),
            (code: 200, weatherType: WeatherType.rainy),
            (code: 300, weatherType: WeatherType.rainy),
            (code: 500, weatherType: WeatherType.rainy),
            (code: 700, weatherType: WeatherType.rainy),
            (code: 100, weatherType: nil)
        ]

        for expectation in expectations {
            let weatherType = WeatherCodeFilter.filter(code: expectation.code)
            XCTAssertEqual(weatherType, expectation.weatherType)
        }
    }
    
    func testWeatherDateAverageFilter() throws {
        let date1_1 = "{\"dt\":1625443200,\"main\":{\"temp\":2,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date1_2 = "{\"dt\":1625454000,\"main\":{\"temp\":4,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date1_3 = "{\"dt\":1625464800,\"main\":{\"temp\":6,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date1_4 = "{\"dt\":1625475600,\"main\":{\"temp\":8,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        
        let date2_1 = "{\"dt\":1625529600,\"main\":{\"temp\":4,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date2_2 = "{\"dt\":1625540400,\"main\":{\"temp\":4,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date2_3 = "{\"dt\":1625551200,\"main\":{\"temp\":4,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let date2_4 = "{\"dt\":1625562000,\"main\":{\"temp\":4,\"feels_like\":34.91,\"temp_min\":37.93,\"temp_max\":37.93,\"pressure\":1007,\"sea_level\":1007,\"grnd_level\":953,\"humidity\":9,\"temp_kf\":0},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":81},\"wind\":{\"speed\":6.65,\"deg\":31,\"gust\":7.37},\"visibility\":10000,\"pop\":0,\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2021-07-05 15:00:00\"}"
        let datesJSON = [date1_1, date1_2, date1_3, date1_4, date2_1, date2_2, date2_3, date2_4]
        let datesJSONData = datesJSON.map { $0.data(using: .utf8)! }
        let models = datesJSONData.map { try! JSONDecoder().decode(ForecastModel.self, from: $0) }
        
        let model = WeatherDateAverageFilter.filter(models: models)
        XCTAssertEqual(model.count, 2)
        XCTAssertEqual(model[0].temperature, 5.0)
        XCTAssertEqual(model[1].temperature, 4.0)
    }
    
    // Service Tests
    
    func testWeatherServiceSuccess() throws {
        let expectation = XCTestExpectation(description: "Weather Service Loads Current and Forecast data if there are no errors")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let service = WeatherService(session: urlSessionMocked)
        
        let location = CLLocation(latitude: CLLocationDegrees(22), longitude: CLLocationDegrees(22))
        service.getWeather(at: location) { result in
            switch result {
            case let .success((current, forecast)):
                XCTAssertEqual(current?.currentTemperature, 37.93)
                XCTAssertEqual(current?.maxTemperature, 37.93)
                XCTAssertEqual(current?.minTemperature, 37.93)
                XCTAssertEqual(current?.weather.first?.id, 803)
                XCTAssertEqual(current?.weather.first?.main, "Clouds")
                XCTAssertEqual(current?.weather.first?.description, "broken clouds")
                XCTAssertEqual(current?.weather.first?.icon, "04d")
                
                XCTAssertEqual(forecast?.list.count, 6)
                
                // I simply sample the first item in the list to see that the forecast is working.
                let firstForecast = forecast?.list.first
                XCTAssertEqual(firstForecast?.temperature, 35.696666666666665)
                XCTAssertEqual(firstForecast?.date?.timeIntervalSinceReferenceDate, 647190000.0)
                XCTAssertEqual(firstForecast?.weather.first?.id, 803)
                XCTAssertEqual(firstForecast?.weather.first?.main, "Clouds")
                XCTAssertEqual(firstForecast?.weather.first?.description, "broken clouds")
                XCTAssertEqual(firstForecast?.weather.first?.icon, "04d")
                
                expectation.fulfill()
            case .failure(_):
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testWeatherServiceFailing() throws {
        let expectation = XCTestExpectation(description: "Weather Service Fails When Receiving A Network Error")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMockFailing.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let service = WeatherService(session: urlSessionMocked)
        
        let location = CLLocation(latitude: CLLocationDegrees(22), longitude: CLLocationDegrees(22))
        service.getWeather(at: location) { result in
            switch result {
            case .success(_):
                XCTFail()
            case let .failure(error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    // Controller Tests
    
    func testWeatherControllerSuccess() throws {
        let expectation = XCTestExpectation(description: "Controller Loads ViewModels")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMock.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let service = WeatherService(session: urlSessionMocked)
        let gpsServiceMock = GPSServiceMock(status: .authorizedAlways)
        
        let weatherController = WeatherController(weatherService: service, gpsService: gpsServiceMock)
        weatherController.weatherDidUpdate.add { success in
            XCTAssertEqual(success, true)
            let current = weatherController.current
            let forecast = weatherController.forecast
            
            XCTAssertEqual(current.currentTemperature, "37.93°")
            XCTAssertEqual(current.maxTemperature, "37.93°")
            XCTAssertEqual(current.minTemperature, "37.93°")
            XCTAssertEqual(current.weatherType, .cloudy)
            XCTAssertEqual(current.backgroundColor, WeatherType.cloudy.color)
            
            XCTAssertEqual(forecast.count, 6)
            
            // I simply sample the first item in the list to see that the forecast is working.
            let firstForecast = forecast.first
            XCTAssertEqual(firstForecast?.temperature, "35.70°")
            XCTAssertEqual(firstForecast?.day, "Monday")
            XCTAssertEqual(firstForecast?.weatherType, .cloudy)
            XCTAssertEqual(firstForecast?.image, WeatherType.cloudy.forecastImage)
            XCTAssertEqual(firstForecast?.backgroundColor, WeatherType.cloudy.color)
            
            expectation.fulfill()
        }
        weatherController.refresh()
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    func testWeatherControllerFailing() throws {
        let expectation = XCTestExpectation(description: "Controller Loads ViewModels")
        
        let config = URLSessionConfiguration.default
        config.protocolClasses = [URLProtocolMockFailing.self]
        let urlSessionMocked = URLSession.init(configuration: config)
        let service = WeatherService(session: urlSessionMocked)
        let gpsServiceMock = GPSServiceMock(status: .authorizedAlways)
        
        let weatherController = WeatherController(weatherService: service, gpsService: gpsServiceMock)
        weatherController.weatherDidUpdate.add { success in
            XCTAssertEqual(success, false)
            expectation.fulfill()
        }
        weatherController.refresh()
        
        wait(for: [expectation], timeout: 15.0)
    }
    
    // Helper Functions
    
    static func load(file: String) throws -> Data {
        let testBundle = Bundle(for: Self.self)
        guard let url = testBundle.url(forResource: file, withExtension: "json") else {
            fatalError()
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError()
        }
        return data
    }
}
