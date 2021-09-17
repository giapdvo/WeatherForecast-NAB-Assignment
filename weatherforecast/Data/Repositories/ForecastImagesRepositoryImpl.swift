//
//  ForecastImagesRepositoryImpl.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/17/21.
//

import Foundation
final class ForecastImagesRepositoryImpl {
    
    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    }
}

extension ForecastImagesRepositoryImpl: ForecastImagesRepository {
    
    func fetchImage(with imageCode: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        let endpoint = APIEndpoints.getWeatherImage(imgCode: imageCode)
        let task = RepositoryTask()
        
        task.networkTask = dataTransferService.request(with: endpoint) { (result: Result<Data, DataTransferError>) in
            let result = result.mapError { $0 as Error }
            DispatchQueue.main.async { completion(result) }
        }
        return task
    }
}
