//
//  AppDIContainer.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiDataTransferService: DataTransferService = {
        
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["appid" : appConfiguration.appId])
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
   
    
    
    
    // MARK: - DIContainers of scenes
    func makeWeatherForecastSceneDIContainer() -> WeatherForecastSceneDIContainer {
        let dependencies = WeatherForecastSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return WeatherForecastSceneDIContainer(dependencies: dependencies)
    }
   
}
