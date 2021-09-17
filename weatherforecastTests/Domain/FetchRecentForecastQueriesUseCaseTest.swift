//
//  FetchRecentForecastQueriesUseCaseTest.swift
//  weatherforecastTests
//
//  Created by Giap Vo on 9/17/21.
//

import XCTest

class FetchRecentForecastQueriesUseCaseTest: XCTestCase {
    
    var forecastQueries = [ForecastQuery(query: "hanoi"),
                           ForecastQuery(query: "saigon"),
                           ForecastQuery(query: "london"),
                           ForecastQuery(query: "sysney"),
                           ForecastQuery(query: "texas")]

    class ForecastQueriesRepositoryMock: ForecastQueriesRepository {
        var recentQueries: [ForecastQuery] = []

        func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[ForecastQuery], Error>) -> Void) {
            completion(.success(recentQueries))
        }
        func saveRecentQuery(query: ForecastQuery, completion: @escaping (Result<ForecastQuery, Error>) -> Void) {
            recentQueries.append(query)
        }
    }
    
    
    func testFetchRecentForecastUseCase_shouldReturnRecentQueries() {
        // given
        let expectation = self.expectation(description: "fetchRecentsQueries should call")
        expectation.expectedFulfillmentCount = 1

        let forecastQueriesRepository = ForecastQueriesRepositoryMock()
        forecastQueriesRepository.recentQueries = forecastQueries
     
        var recents = [ForecastQuery]()

        let usecase = DefaultFetchRecentForecastQueriesUseCase(forecastQueriesRepository: forecastQueriesRepository)
        _ = usecase.execute(params: FetchRecentForcastUseCaseRequest(maxCount: 5)) { result in
            recents = (try? result.get()) ?? []
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(recents.count, 5)
        
    }

}
