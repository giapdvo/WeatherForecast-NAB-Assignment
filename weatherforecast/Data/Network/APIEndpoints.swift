//
//  APIEndpoints.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation
struct APIEndpoints {
    static func getForecast(with forecastRequestDTO: ForecastRequestDTO) -> Endpoint<ForecastResponseDTO> {
        return Endpoint(path: "daily", method: .get, queryParametersEncodable: forecastRequestDTO)
    }
    
    static func getWeatherImage(imgCode: String) -> Endpoint<Data> {
        return Endpoint(path: "http://openweathermap.org/img/wn/\(imgCode)@2x.png",
                         isFullPath: true,
                         method: .get,
                         responseDecoder: RawDataResponseDecoder())
    }
}
