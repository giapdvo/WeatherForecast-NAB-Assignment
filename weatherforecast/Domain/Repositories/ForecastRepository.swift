//
//  ForecastRepository.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

protocol ForecastRepository {
    @discardableResult
    func fetchForecastList(query: ForecastQuery,
                         cached: @escaping (Forecast) -> Void,
                         completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable?
}
