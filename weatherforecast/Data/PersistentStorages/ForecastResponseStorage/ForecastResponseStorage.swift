//
//  ForecastResponseStorage.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

protocol ForecastResponseStorage {
    func getResponse(for request: ForecastRequestDTO, completion: @escaping (Result<ForecastResponseDTO?, CoreDataStorageError>) -> Void)
    func save(response: ForecastResponseDTO, for requestDto: ForecastRequestDTO)
}
