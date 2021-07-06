//
//  WeatherDateAverageFilter.swift
//  DVTWeatherUIKit
//
//  Created by Kurt Jacobs
//

import Foundation

/*
    This class exists because the API endpoint (/forecast) specified provides the 5 day forecast but in three hour increments per day. Consequently, I've opted to combine each of the same date models into a single model using averaging only on the temperature property.  There are 24 hours in a day at 3 hour increments gives us 8 samples (max). I'm not too sure about how the weather averaging works w.r.t model (I would need to read more about that) but perhaps 8 samples is sufficient. Prefereably we should have used the other endpoint (/onecall) that includes the averages from the server side. I'm not sure if this was part of the exercise so I've decided to stick with this endpoint. Personally I'm a fan of the server doing more of the work (sure the server incurs the compute cost but we save the cost for each and every mobile device by doing the compute once and simply displaying the data on the client side).
 
        Perhaps a nicer layout for this data would be one in which the 3 hour interval data is displayed in a carousel per date instead of having to average the data manually (something similar to the default iOS weather application). Design discussion point if you're open to that. NOTE: If you just have the filter return the unmodified models you can see the three hour interval data in the rendered list.
 */

class WeatherDateAverageFilter {
    static func filter(models: [ForecastModel]) -> [ForecastModel] {
        let unique = uniqueDays(models: models)
        let averaged = averageOfThreeHour(models, uniqueDays: unique)
        return averaged
    }
    
    static private func averageOfThreeHour(_ models: [ForecastModel], uniqueDays: [Date]) -> [ForecastModel] {
        // using the unique days we drop each of the models into a bucket matching the unique day.
        var dictionary: [Date: [ForecastModel]] = [:]
        for day in uniqueDays {
            for model in models {
                guard let modelDate = model.date else {
                    continue
                }
                if Calendar.current.isDate(day, inSameDayAs: modelDate) {
                    if dictionary[day] == nil {
                        dictionary[day] = []
                    }
                    dictionary[day]?.append(model)
                }
            }
        }
        
        // we compute the averages for the buckets defined above.
        var averagedModels: [ForecastModel] = []
        for day in uniqueDays {
            guard let uniqueModels = dictionary[day] else { continue }
            let average = uniqueModels.reduce(0.0) { result, model in result + model.temperature } / Double(uniqueModels.count)
            guard var firstModel = uniqueModels.first else { continue }
            firstModel.temperature = average
            averagedModels.append(firstModel)
        }
        
        return averagedModels
    }
    
    static private func uniqueDays(models: [ForecastModel]) -> [Date] {
        let dates = models.compactMap { $0.date?.removeTimeStamp }
        return Array(Set<Date>(dates)).sorted()
    }

}
