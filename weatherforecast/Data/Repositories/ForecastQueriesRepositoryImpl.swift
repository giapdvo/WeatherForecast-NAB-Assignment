//
//  ForecastQueriesRepositoryImpl.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

final class ForecastQueriesRepositoryImpl {
    private let dataTransferService: DataTransferService
    private var forecastQueriesPersistentStorage: ForecastQueriesStorage
    
    init(dataTransferService: DataTransferService,
         forecastQueriesPersistentStorage: ForecastQueriesStorage) {
        self.dataTransferService = dataTransferService
        self.forecastQueriesPersistentStorage = forecastQueriesPersistentStorage
    }
}

extension ForecastQueriesRepositoryImpl: ForecastQueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ForecastQuery], Error>) -> Void) {
        return forecastQueriesPersistentStorage.fetchRecentsQueries(maxCount: maxCount, completion: completion)
    }
    
    func saveRecentQuery(query: ForecastQuery, completion: @escaping (Result<ForecastQuery, Error>) -> Void) {
        forecastQueriesPersistentStorage.saveRecentQuery(query: query, completion: completion)
    }
    
    
}

