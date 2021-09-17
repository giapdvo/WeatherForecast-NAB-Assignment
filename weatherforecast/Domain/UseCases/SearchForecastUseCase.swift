//
//  SearchForecastUseCase.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation


protocol SearchForecastUseCase {
    func execute(params: SearchForecastUseCaseRequest,
                 cached: @escaping (Forecast) -> Void,
                 completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable?
}



final class DefaultSearchForecastUseCase: SearchForecastUseCase {
    
    typealias Params = SearchForecastUseCaseRequest
    typealias R = Forecast
    
    private let forecastRepository: ForecastRepository
    private let forecastQueriesRepository: ForecastQueriesRepository
    
    init(forecastRepository: ForecastRepository,
         forecastQueriesRepository: ForecastQueriesRepository) {
        
        self.forecastRepository = forecastRepository
        self.forecastQueriesRepository = forecastQueriesRepository
    }
    
    func execute(params: SearchForecastUseCaseRequest,
                 cached: @escaping (Forecast) -> Void,
                 completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable? {

        return forecastRepository.fetchForecastList(query: params.query, cached: cached) { result in

            if case .success = result {
                self.forecastQueriesRepository.saveRecentQuery(query: params.query) { _ in }
            }

            completion(result)
        }
    }
    
    
}


struct SearchForecastUseCaseRequest {
    let query: ForecastQuery
}
