//
//  ForecastSearchFlowCoordinator.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

protocol ForecastSearchFlowCoordinatorDependencies  {
    func makeForecastListViewController(actions: ForecastListViewModelActions) -> ForecastListViewController
    func makeForecastQueriesSuggestionsListViewController(didSelect: @escaping ForecastQueryListViewModelDidSelectAction) -> UIViewController
}

final class ForecastSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: ForecastSearchFlowCoordinatorDependencies

    private weak var forecastListVC: ForecastListViewController?
    private weak var forecastQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: ForecastSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        let actions = ForecastListViewModelActions(showForecastQueriesSuggestions: showForecastQueriesSuggestions, closeForecastQueriesSuggestions: closeForecastQueriesSuggestions)
        let vc = dependencies.makeForecastListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        forecastListVC = vc
    }

    private func showForecastDetails(forecast: Forecast) {
       
    }

    private func showForecastQueriesSuggestions(didSelect: @escaping (ForecastQuery) -> Void) {
        guard let forecastListViewController = forecastListVC, forecastQueriesSuggestionsVC == nil,
            let container = forecastListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeForecastQueriesSuggestionsListViewController(didSelect: didSelect)

        forecastListViewController.add(child: vc, container: container)
        forecastQueriesSuggestionsVC = vc
        container.isHidden = false
    }

    private func closeForecastQueriesSuggestions() {
        forecastQueriesSuggestionsVC?.remove()
        forecastQueriesSuggestionsVC = nil
        forecastListVC?.suggestionsListContainer.isHidden = true
    }
}
