//
//  WeatherQuery.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

enum Unit: String {
    case standard
    case metric
    case imperial
}

struct ForecastQuery: Equatable {
    let query: String
    let numberOfDay: Int = 7
    let units: Unit = .metric
}
