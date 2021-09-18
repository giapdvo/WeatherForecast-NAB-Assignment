//
//  ForecastListItemViewModel.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation

struct ForecastListItemViewModel: Equatable {
    let date: String
    let temperature: String
    let pressure: String
    let humidity: String
    let description: String
    let imagePath: String
}

extension ForecastListItemViewModel {
    init(forecastDay: ForeCastDay) {
        humidity = "\(forecastDay.humidity)%"
        date = forecastDay.dt.getDateStringFromUTC()
        temperature = averageTempurature(temp: forecastDay.temp)
        pressure = "\(forecastDay.pressure)"
        description = forecastDay.weather.first?.description ?? "N/A"
        imagePath = forecastDay.weather.first?.icon ?? "01d"
    }
    
    
   
    
}

private func averageTempurature(temp: ForeCastDay.Tempurature) -> String {
    let average = (temp.min + temp.max) / 2
    return round(average).toTemperature(unit: .celsius)
}

