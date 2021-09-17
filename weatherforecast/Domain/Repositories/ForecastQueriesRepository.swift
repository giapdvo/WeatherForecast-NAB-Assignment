//
//  ForecastQueriesRepository.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

protocol ForecastQueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ForecastQuery], Error>) -> Void)
    func saveRecentQuery(query: ForecastQuery, completion: @escaping (Result<ForecastQuery, Error>) -> Void)
}
