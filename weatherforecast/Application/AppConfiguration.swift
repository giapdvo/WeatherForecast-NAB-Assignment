//
//  AppConfiguration.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

final class AppConfiguration {

    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    
    lazy var appId: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "AppId") as? String else {
            fatalError("AppId must not be empty in plist")
        }
        return apiKey
    }()
    
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
   
}
