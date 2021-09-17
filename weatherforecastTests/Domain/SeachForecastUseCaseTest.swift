//
//  SeachForecastUseCaseTest.swift
//  weatherforecastTests
//
//  Created by Giap Vo on 9/17/21.
//

import XCTest

class SeachForecastUseCaseTest: XCTestCase {
    
    
    //MARK: - Prepare Test Data
    
    static let forecast: Forecast =  {
        let forecastDay1 = ForeCastDay(dt: 1631851200, sunrise: 1631832172, sunset: 1631875989, temp: .init(day: 31.76, min:  24.36, max: 32.27, night: 25.8, eve: 30.42, morn: 4.36), pressure: 1009, humidity: 63, weather: [ForeCastDay.Weather.init(id: 500, main: "Rain", description: "light rain", icon: "10d")], speed: 3.25, deg: 162, gust: 5.73, clouds: 42, pop: 0.96, rain: 2.5)
        
        return Forecast(id: 1, list: [forecastDay1])
    }()
    
    enum ForecastRepositoryTestError: Error {
        case failedFetching
    }

    class ForecastQueriesRepositoryMock: ForecastQueriesRepository {
        var recentQueries: [ForecastQuery] = []
        
        func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ForecastQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: ForecastQuery, completion: @escaping (Result<ForecastQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }
    
    struct ForecastRepositoryMock: ForecastRepository {
        var result: Result<Forecast, Error>
        func fetchForecastList(query: ForecastQuery, cached: @escaping (Forecast) -> Void, completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancellable? {
            completion(result)
            return nil
        }
    }
    
    //MARK: - Test cases
    
    func testSearchForecastUseCase_whenSuccessFullyFetchesForQuery_thenQueryIsSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let forecastQueriesRepository = ForecastQueriesRepositoryMock()
        let useCase = DefaultSearchForecastUseCase(forecastRepository: ForecastRepositoryMock(result: .success(SeachForecastUseCaseTest.forecast)), forecastQueriesRepository: forecastQueriesRepository)

        // when
        let query = SearchForecastUseCaseRequest(query: ForecastQuery(query: "Hanoi"))
        _ = useCase.execute(params: query, cached: { _ in }, completion: { _ in
            expectation.fulfill()
        })
        // then
        var recents = [ForecastQuery]()
        forecastQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(recents.contains(ForecastQuery(query: "Hanoi")),"The queries should be saved to the recent.")
    }
    
    func testSearchForecastUseCase_whenFailedFetchesForQuery_thenQueryShouldNotSavedInRecentQueries() {
        // given
        let expectation = self.expectation(description: "Recent query saved")
        expectation.expectedFulfillmentCount = 2
        let forecastQueriesRepository = ForecastQueriesRepositoryMock()
        let useCase = DefaultSearchForecastUseCase(forecastRepository: ForecastRepositoryMock(result: .failure(ForecastRepositoryTestError.failedFetching)), forecastQueriesRepository: forecastQueriesRepository)

        // when
        let query = SearchForecastUseCaseRequest(query: ForecastQuery(query: "Hanoi"))
        _ = useCase.execute(params: query, cached: { _ in }, completion: { _ in
            expectation.fulfill()
        })
        // then
        var recents = [ForecastQuery]()
        forecastQueriesRepository.fetchRecentsQueries(maxCount: 1) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(recents.isEmpty, "The recents query should not be saved.")
    }

}
