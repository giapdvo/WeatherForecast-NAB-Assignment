//
//  ForecastsResponseEntity+Mapping.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation
import CoreData

//MARK - Entity to DTO

extension ForecastsResponseEntity {
    func toDTO() -> ForecastResponseDTO? {
        return .init(city: ForecastResponseDTO.City(id: id.hashValue, name: cityName ?? "", country: cityCountry ?? ""), cnt: Int(cnt), list: forecasts?.allObjects.map{($0 as! ForecastDayResponseEntity).toDTO()} ?? [])
    }
}


extension ForecastDayResponseEntity {
    func toDTO() ->  ForecastResponseDTO.ForeCastDay {
        let tempurature = ForecastResponseDTO.ForeCastDay.Tempurature(day: tempDay, min: tempMin, max: tempMax, night: tempNight, eve: tempEve, morn: tempMorn)
        let weather = ForecastResponseDTO.ForeCastDay.Weather(id: Int(weatherId), main: weatherMain ?? "", description: weatherDescription ?? "", icon: weatherIcon ?? "")
        return .init(dt: dt,
                     sunrise: Int(sunrise),
                     sunset: Int(sunset),
                     temp: tempurature,
                     pressure: Int(pressure),
                     humidity: Int(humidity),
                     weather: [weather],
                     speed: speed,
                     deg: Int(deg),
                     gust: gust,
                     clouds: Int(clouds),
                     pop: Double(pop),
                     rain: rain)
    }
}

//MARK - DTO to Entity

extension ForecastRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> ForecastRequestEntity {
        let entity: ForecastRequestEntity = .init(context: context)
        entity.q = q
        entity.cnt = Int32(cnt)
        entity.units = units
        entity.createdAt = Date()
        return entity
    }
}

extension ForecastResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> ForecastsResponseEntity {
        let entity: ForecastsResponseEntity = .init(context: context)
        entity.cnt = Int32(cnt)
        entity.cityId = Int32(city.id)
        entity.cityName = city.name
        entity.cityCountry = city.country
        list.forEach{
            entity.addToForecasts($0.toEntity(in: context))
        }
        return entity
    }
}

extension ForecastResponseDTO.ForeCastDay {
    func toEntity(in context: NSManagedObjectContext) -> ForecastDayResponseEntity {
        let entity: ForecastDayResponseEntity = .init(context: context)
        entity.clouds = Int32(clouds)
        entity.deg = Int32(deg)
        entity.dt = dt
        entity.gust = gust
        entity.humidity = Int32(humidity)
        entity.pop = Double(pop)
        entity.pressure = Int32(pressure)
        entity.rain = rain ?? 0.0
        entity.speed = speed
        entity.sunrise = Int32(sunrise)
        entity.sunset = Int32(sunset)
        entity.tempDay = temp.day
        entity.tempEve = temp.eve
        entity.tempMax = temp.max
        entity.tempMin = temp.min
        entity.tempNight = temp.night
        entity.tempMorn = temp.morn
        entity.weatherMain = weather.first?.main
        entity.weatherDescription = weather.first?.description
        entity.weatherIcon = weather.first?.icon
        return entity
    }
}
