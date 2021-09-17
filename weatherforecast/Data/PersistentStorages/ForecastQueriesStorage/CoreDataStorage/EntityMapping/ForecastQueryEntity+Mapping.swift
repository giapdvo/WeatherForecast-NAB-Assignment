//
//  ForecastQueryEntity+Mapping.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation
import CoreData

extension ForecastQueryEntity {
    convenience init(forecastQuery: ForecastQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = forecastQuery.query
        createdAt = Date()
    }
}

extension ForecastQueryEntity {
    func toDomain() -> ForecastQuery {
        return .init(query: query ?? "")
    }
}
