//
//  ForecastQueryListViewModel.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation


typealias ForecastQueryListViewModelDidSelectAction = (ForecastQuery) -> Void

protocol ForecastQueryListViewModelInput {
    func viewWillAppear()
    func didSelect(item: ForecastQueryListItemViewModel)
}

protocol ForecastQueryListViewModelOutput {
    var items: Observable<[ForecastQueryListItemViewModel]> { get }
}

protocol ForecastQueryListViewModel: ForecastQueryListViewModelInput, ForecastQueryListViewModelOutput { }

final class DefaultForecastQueryListViewModel: ForecastQueryListViewModel {

    private let numberOfQueriesToShow: Int
    private let fetchRecentForecastQueriesUseCase: FetchRecentForecastQueriesUseCase
    private let didSelect: ForecastQueryListViewModelDidSelectAction?
    
    // MARK: - OUTPUT
    let items: Observable<[ForecastQueryListItemViewModel]> = Observable([])
    
    init(numberOfQueriesToShow: Int,
         fetchRecentForecastQueriesUseCase: FetchRecentForecastQueriesUseCase,
         didSelect: ForecastQueryListViewModelDidSelectAction? = nil) {
        self.numberOfQueriesToShow = numberOfQueriesToShow
        self.fetchRecentForecastQueriesUseCase = fetchRecentForecastQueriesUseCase
        self.didSelect = didSelect
    }
    
    private func updateForecastQueries() {
    
        fetchRecentForecastQueriesUseCase.execute(params: .init(maxCount: numberOfQueriesToShow)) { result in
            switch result {
            case .success(let items):
                self.items.value = items.map { $0.query }.map(ForecastQueryListItemViewModel.init)
            case .failure: break
            }
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultForecastQueryListViewModel {
        
    func viewWillAppear() {
        updateForecastQueries()
    }
    
    func didSelect(item: ForecastQueryListItemViewModel) {
        didSelect?(ForecastQuery(query: item.query))
    }
}
