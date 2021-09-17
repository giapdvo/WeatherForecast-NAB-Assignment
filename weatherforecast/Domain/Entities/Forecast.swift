//
//  WeatherForecast.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

struct Forecast: Equatable, Identifiable {
    
    typealias Identifier = Int
    
    let id: Identifier
    let list: [ForeCastDay]
}


struct ForeCastDay: Equatable {
    struct Tempurature : Equatable{
        let day: Double             // Day temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let min: Double             // Min daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let max: Double             // Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let night: Double           // Night temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let eve: Double             // Evening temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
        let morn: Double            // Morning temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
    }
    
    struct Weather: Equatable {
        let id: Int                 // Weather condition id
        let main: String            // Group of weather parameters (Rain, Snow, Extreme etc.)
        let description: String     // Weather condition within the group. You can get the output in your language
        let icon: String            // Weather icon id
    }
    
    let dt: Double                  // Time of data forecasted
    let sunrise: Int
    let sunset: Int
    let temp: Tempurature
    let pressure: Int               // Atmospheric pressure on the sea level, hPa
    let humidity: Int               // Humidity, %
    let weather: [Weather]          // Weather condition codes
    let speed: Double               // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    let deg: Int                    // Wind direction, degrees (meteorological)
    let gust: Double                // Wind gust. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
    let clouds: Int                 // Cloudiness, %
    let pop: Double                    // Probability of precipitation
    let rain: Double                // Precipitation volume, mm

}
