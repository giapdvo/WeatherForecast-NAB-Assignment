//
//  NetworkConfigurableMock.swift
//  weatherforecastTests
//
//  Created by Giap Vo on 9/17/21.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
