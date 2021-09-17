//
//  FetchRecentForecastQueriesUseCase.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation


protocol FetchRecentForecastQueriesUseCase {
    @discardableResult
    func execute(params: FetchRecentForcastUseCaseRequest,
                 completion: @escaping (Result<[ForecastQuery], Error>) -> Void) -> Cancellable?
}

final class DefaultFetchRecentForecastQueriesUseCase: FetchRecentForecastQueriesUseCase {
   
    
    private let forecastQueriesRepository: ForecastQueriesRepository
    
    
    typealias ResultValue = (Result<[ForecastQuery], Error>)

    
    init(forecastQueriesRepository: ForecastQueriesRepository) {
        self.forecastQueriesRepository = forecastQueriesRepository
    }
    
    func execute(params: FetchRecentForcastUseCaseRequest,
                 completion: @escaping (ResultValue) -> Void) -> Cancellable? {
        forecastQueriesRepository.fetchRecentsQueries(maxCount: params.maxCount) { result in
            completion(result)
        }
        return nil
    }
    
}


struct FetchRecentForcastUseCaseRequest {
    let maxCount: Int
}
