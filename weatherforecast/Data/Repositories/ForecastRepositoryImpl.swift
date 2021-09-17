//
//  ForecastRepositoryImpl.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

final class ForecastRepositoryImpl {
    private let dataTransferService: DataTransferService
    private let cache: ForecastResponseStorage

    init(dataTransferService: DataTransferService, cache: ForecastResponseStorage) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}


extension ForecastRepositoryImpl: ForecastRepository {
    func fetchForecastList(query: ForecastQuery, cached: @escaping (Forecast) -> Void, completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable? {
        let requestDTO = ForecastRequestDTO(q: query.query, cnt: query.numberOfDay, units: query.units.rawValue)
        let task = RepositoryTask()
        cache.getResponse(for: requestDTO) { result in
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
                task.cancel()
            }
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getForecast(with: requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    self.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
       
        return task
    }
    
    
}
