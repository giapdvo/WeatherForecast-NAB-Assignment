//
//  AppFlowCoordinator.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import UIKit

final class AppFlowCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        
        let forecastSceneDIContainer = appDIContainer.makeWeatherForecastSceneDIContainer()
        let flow = forecastSceneDIContainer.makeForecastSearchFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}
