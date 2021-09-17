//
//  ForecastResponseDTO+Mapping.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation


struct ForecastResponseDTO: Decodable {
    
    let city: City
    let cnt: Int                    //number of forecast days
    let list: [ForeCastDay]
}


extension ForecastResponseDTO {
    
    struct Coordinate : Decodable{
        let lon: Double
        let lat: Double
    }
    
    struct City : Decodable{
        let id: Int                 // City ID
        let name: String            // City name
        let country: String         // Country code (GB, JP etc.)
    }
    
    struct ForeCastDay : Decodable  {
        struct Tempurature: Decodable  {
            let day: Double             // Day temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
            let min: Double             // Min daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
            let max: Double             // Max daily temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
            let night: Double           // Night temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
            let eve: Double             // Evening temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
            let morn: Double            // Morning temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.

        }
        
        struct Weather : Decodable {
            let id: Int                 // Weather condition id
            let main: String            // Group of weather parameters (Rain, Snow, Extreme etc.)
            let description: String     // Weather condition within the group. You can get the output in your language
            let icon: String            // Weather icon id
        }
        
        let dt: Double                     // Time of data forecasted
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
        let rain: Double?                // Precipitation volume, mm
    }

}

//MARK: - Mappings to domain

extension ForecastResponseDTO {
    func toDomain() -> Forecast {
        return .init(id: city.id, list: list.map{$0.toDomain()})
    }
}

extension ForecastResponseDTO.ForeCastDay {
    func toDomain() -> ForeCastDay {
        return .init(dt: dt, sunrise: sunrise, sunset: sunset, temp: temp.toDomain(), pressure: pressure, humidity: humidity, weather: weather.map{$0.toDomain()}, speed: speed, deg: deg, gust: gust, clouds: clouds, pop: pop, rain: rain ?? 0.0)
    }
}


extension ForecastResponseDTO.ForeCastDay.Tempurature {
    func toDomain() -> ForeCastDay.Tempurature {
        return .init(day: day, min: min, max: max, night: night, eve: eve, morn: morn)
    }
}


extension ForecastResponseDTO.ForeCastDay.Weather {
    func toDomain() -> ForeCastDay.Weather {
        return .init(id: id, main: main, description: description, icon: icon)
    }
}
