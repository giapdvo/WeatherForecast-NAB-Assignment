//
//  ForecastListViewModelTests.swift
//  weatherforecastTests
//
//  Created by Giap Vo on 9/17/21.
//

import XCTest

class ForecastListViewModelTests: XCTestCase {
    
    private enum SearchForecastUseCaseError: Error {
        case someError
    }

    static let forecast: Forecast =  {
        let forecastDay1 = ForeCastDay(dt: 1631851200, sunrise: 1631832172, sunset: 1631875989, temp: .init(day: 31.76, min:  24.36, max: 32.27, night: 25.8, eve: 30.42, morn: 4.36), pressure: 1009, humidity: 63, weather: [ForeCastDay.Weather.init(id: 500, main: "Rain", description: "light rain", icon: "10d")], speed: 3.25, deg: 162, gust: 5.73, clouds: 42, pop: 0.96, rain: 2.5)
        
        return Forecast(id: 1, list: [forecastDay1])
    }()
    
    class SearchForecastUseCaseMock: SearchForecastUseCase {
        var expectation: XCTestExpectation?
        var error: Error?
        var resutl = Forecast(id: 1, list: [])
        
        func execute(params: SearchForecastUseCaseRequest, cached: @escaping (Forecast) -> Void, completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(resutl))
            }
            expectation?.fulfill()
            return nil
        }
    }
    
    func test_whenSearchForecastUseCaseRetrievesData_thenViewModelContainsResult() {
        // given
        let searchForecastUseCaseMock = SearchForecastUseCaseMock()
        searchForecastUseCaseMock.expectation = self.expectation(description: "Contain forecast result")
        searchForecastUseCaseMock.resutl = ForecastListViewModelTests.forecast
        let viewModel = DefaultForecastListViewModel(searchForecastUseCase: searchForecastUseCaseMock)
        // when
        viewModel.didSearch(query: "hanoi")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.items.value.count, 1)
    }
    
    func test_whenSearchForecastUseCaseReturnsError_thenViewModelContainsError() {
        // given
        let searchForecastUseCaseMock = SearchForecastUseCaseMock()
        searchForecastUseCaseMock.expectation = self.expectation(description: "contain errors")
        searchForecastUseCaseMock.error = SearchForecastUseCaseError.someError
        let viewModel = DefaultForecastListViewModel(searchForecastUseCase: searchForecastUseCaseMock)
        // when
        viewModel.didSearch(query: "hanoi")
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(viewModel.error)
    }
    

}
