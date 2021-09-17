//
//  ForecastImagesRepository.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/17/21.
//

import Foundation

protocol ForecastImagesRepository {
    func fetchImage(with imageCode: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
