//
//  ForecastListViewModel.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation

struct ForecastListViewModelActions {
    let showForecastQueriesSuggestions: (@escaping (_ didSelect: ForecastQuery) -> Void) -> Void
    let closeForecastQueriesSuggestions: () -> Void
}

enum ForecastListViewModelLoading {
    case fullScreen
}

protocol ForecastListViewModelInput {
    func viewDidLoad()
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
    func didSelectItem(at index: Int)
}

protocol ForecastListViewModelOutput {
    var items: Observable<[ForecastListItemViewModel]> { get }
    var loading: Observable<ForecastListViewModelLoading?> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }
    var searchTextConditionError: String { get }
}

protocol ForecastListViewModel: ForecastListViewModelInput, ForecastListViewModelOutput {}


final class DefaultForecastListViewModel: ForecastListViewModel {

    private let searchForecastUseCase: SearchForecastUseCase
    private let actions: ForecastListViewModelActions?



    private var data: [ForeCastDay] = []
    private var forecastLoadTask: Cancellable? { willSet { forecastLoadTask?.cancel() } }

    // MARK: - OUTPUT

    let items: Observable<[ForecastListItemViewModel]> = Observable([])
    let loading: Observable<ForecastListViewModelLoading?> = Observable(.none)
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
    let screenTitle = NSLocalizedString("Weather Forcast", comment: "")
    let emptyDataTitle = NSLocalizedString("Search results", comment: "")
    let errorTitle = NSLocalizedString("Ops", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Exp: Hanoi", comment: "")
    let searchTextConditionError = NSLocalizedString("City must be at least 3 character.", comment: "")


    // MARK: - Init

    init(searchForecastUseCase: SearchForecastUseCase,
         actions: ForecastListViewModelActions? = nil) {
        self.searchForecastUseCase = searchForecastUseCase
        self.actions = actions
    }

    // MARK: - Private
    private func updateScreen(_ forecast: Forecast) {
        self.loading.value = .none
        let forecastListItem = forecast.list.map(ForecastListItemViewModel.init)
        items.value.append(contentsOf: forecastListItem)
    }
    
    private func resetPages() {
        items.value.removeAll()
    }

    private func load(forecastQuery: ForecastQuery, loading: ForecastListViewModelLoading) {
        self.loading.value = loading
        query.value = forecastQuery.query

        forecastLoadTask = searchForecastUseCase.execute(
            params: .init(query: forecastQuery),
            cached: updateScreen,
            completion: {[weak self] result in
                switch result {
                case .success(let forecast):
                    self?.updateScreen(forecast)
                case .failure(let error):
                    self?.handle(error: error)
                    self?.loading.value = .none
                }

            })
    }

    private func handle(error: Error) {
        self.error.value = error.isInternetConnectionError ?
            NSLocalizedString("No internet connection", comment: "") :
            NSLocalizedString("City not found.", comment: "")
    }

    private func update(forecastQuery: ForecastQuery) {
        resetPages()
        load(forecastQuery: forecastQuery, loading: .fullScreen)
    }
}


// MARK: - INPUT. View event methods

extension DefaultForecastListViewModel {

    func viewDidLoad() { }

    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(forecastQuery: .init(query: query))
    }

    func didCancelSearch() {
        forecastLoadTask?.cancel()
    }

    func showQueriesSuggestions() {
        actions?.showForecastQueriesSuggestions(update(forecastQuery:))
    }

    func closeQueriesSuggestions() {
        actions?.closeForecastQueriesSuggestions()
    }

    func didSelectItem(at index: Int) {
       
    }
}
