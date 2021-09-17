//
//  WeatherForecastSceneDIContainer.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation
import SwiftUI

final class WeatherForecastSceneDIContainer: ForecastSearchFlowCoordinatorDependencies {
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    private let maxCacheLimit = 5
    
    //MARK: - Persistent Storage
    lazy var forecastQueriesStorage: ForecastQueriesStorage = CoreDataForcastQueriesStorage(maxStorageLimit: maxCacheLimit)
    lazy var forecastResponseCache: ForecastResponseStorage = CoreDataForecastResponseStorage(maxStorageLimit: maxCacheLimit)
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    //MARK: - Use Cases
    func makeSearchForecastUseCase() -> SearchForecastUseCase {
        return DefaultSearchForecastUseCase(forecastRepository: makeForecastRepository(), forecastQueriesRepository: makeForecastQueriesRespository())
    }
    
    func makeFetchRecentForecastQueriesUseCase() -> FetchRecentForecastQueriesUseCase {
        return DefaultFetchRecentForecastQueriesUseCase(forecastQueriesRepository: makeForecastQueriesRespository())
    }
    
    //MARK: - Use Repositories
    func makeForecastRepository() -> ForecastRepository {
        return ForecastRepositoryImpl(dataTransferService: dependencies.apiDataTransferService, cache: forecastResponseCache)
    }
    
    func makeForecastQueriesRespository() -> ForecastQueriesRepository {
        return ForecastQueriesRepositoryImpl(dataTransferService: dependencies.apiDataTransferService, forecastQueriesPersistentStorage: forecastQueriesStorage)
    }
    
    func makeForecastImageRepository() -> ForecastImagesRepository {
        return ForecastImagesRepositoryImpl(dataTransferService: dependencies.apiDataTransferService)
    }
    
    //MARK: - Weather Forcast List
    func makeForecastListViewController(actions: ForecastListViewModelActions) -> ForecastListViewController {
        return ForecastListViewController.create(with: makeForecastListViewModel(actions: actions), forecastImagesRepository: makeForecastImageRepository())
    }
    
    func makeForecastListViewModel(actions: ForecastListViewModelActions) -> ForecastListViewModel {
        return DefaultForecastListViewModel(searchForecastUseCase: makeSearchForecastUseCase(),
                                          actions: actions)
    }
    
    //MARK: - Wather Forcast Queries Suggestions List
    func makeForecastQueriesSuggestionsListViewController(didSelect: @escaping ForecastQueryListViewModelDidSelectAction) -> UIViewController {
        if #available(iOS 13.0, *) { // SwiftUI
            let view = ForecastQueryListView(viewModelWrapper: makeForecastQueryListViewModelWrapper(didSelect: didSelect))
            return UIHostingController(rootView: view)
        } else { // UIKit
            return ForecastQueriesTableViewController.create(with: makeForecastQueryListViewModel(didSelect: didSelect))
        }
    }
    
    func makeForecastQueryListViewModel(didSelect: @escaping ForecastQueryListViewModelDidSelectAction) -> ForecastQueryListViewModel {
        return DefaultForecastQueryListViewModel(numberOfQueriesToShow: 10, fetchRecentForecastQueriesUseCase: makeFetchRecentForecastQueriesUseCase(), didSelect: didSelect)
    }

    @available(iOS 13.0, *)
    func makeForecastQueryListViewModelWrapper(didSelect: @escaping ForecastQueryListViewModelDidSelectAction) -> ForecastQueryListViewModelWrapper {
        return ForecastQueryListViewModelWrapper(viewModel: makeForecastQueryListViewModel(didSelect: didSelect))
    }

    
    //MARK: - Flow Coordinators
    func makeForecastSearchFlowCoordinator(navigationController: UINavigationController) -> ForecastSearchFlowCoordinator {
        return ForecastSearchFlowCoordinator(navigationController: navigationController,
                                           dependencies: self)
    }
    
}
