//
//  ForecastRequestDTO+Mapping.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

struct ForecastRequestDTO: Encodable {
    let q: String
    let cnt: Int 
    let units: String
}
