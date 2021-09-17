//
//  ForecastQueriesListViewModel.swift
//  weatherforecastTests
//
//  Created by Giap Vo on 9/17/21.
//

import XCTest

class ForecastQueriesListViewModel: XCTestCase {

    private enum FetchRecentQueriedUseCase: Error {
        case someError
    }
    
    var forecastQueries = [ForecastQuery(query: "hanoi"),
                           ForecastQuery(query: "saigon"),
                           ForecastQuery(query: "london"),
                           ForecastQuery(query: "sysney"),
                           ForecastQuery(query: "texas")]
    
    class FetchRecentForecastQueriesUseCaseMock: FetchRecentForecastQueriesUseCase {
      
        var expectation: XCTestExpectation?
        var error: Error?
        var forecastQueries: [ForecastQuery] = []
        var completion: (Result<[ForecastQuery], Error>) -> Void = { _ in }
        
        
        func execute(params: FetchRecentForcastUseCaseRequest, completion: @escaping (Result<[ForecastQuery], Error>) -> Void) -> Cancellable? {
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(forecastQueries))
            }
            expectation?.fulfill()
            return nil
        }

    }
    
    func test_whenFetchRecentForecastQueriesUseCaseReturnsQueries_thenShowTheseQueries() {
        // given
        let useCase = FetchRecentForecastQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.forecastQueries = forecastQueries
        let viewModel = DefaultForecastQueryListViewModel(numberOfQueriesToShow: 5, fetchRecentForecastQueriesUseCase: useCase)

        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(viewModel.items.value.map { $0.query }, forecastQueries.map { $0.query })
    }
    
    func test_whenFetchRecentForecastQueriesUseCaseReturnsError_thenDontShowAnyQuery() {
        // given
        let useCase = FetchRecentForecastQueriesUseCaseMock()
        useCase.expectation = self.expectation(description: "Recent query fetched")
        useCase.error = FetchRecentQueriedUseCase.someError
        let viewModel = DefaultForecastQueryListViewModel(numberOfQueriesToShow: 5, fetchRecentForecastQueriesUseCase: useCase)
        
        // when
        viewModel.viewWillAppear()
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(viewModel.items.value.isEmpty)
    }
    
    func test_whenDidSelectQueryEventIsReceived_thenCallDidSelectAction() {
        // given
        let selectedQueryItem = ForecastQuery(query: "query1")
        var actionForecastQuery: ForecastQuery?
        let expectation = self.expectation(description: "Delegate notified")
        let didSelect: ForecastQueryListViewModelDidSelectAction = { query in
            actionForecastQuery = query
            expectation.fulfill()
        }
        
        let viewModel = DefaultForecastQueryListViewModel(numberOfQueriesToShow: 5, fetchRecentForecastQueriesUseCase: FetchRecentForecastQueriesUseCaseMock(), didSelect: didSelect)
        
        // when
        viewModel.didSelect(item: ForecastQueryListItemViewModel(query: selectedQueryItem.query))
        
        // then
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(actionForecastQuery, selectedQueryItem)
    }
    



}
