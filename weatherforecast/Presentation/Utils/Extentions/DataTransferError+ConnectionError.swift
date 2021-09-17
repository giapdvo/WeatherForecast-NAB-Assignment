//
//  DataTransferError+ConnectionError.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation

extension DataTransferError: ConnectionError {
    public var isInternetConnectionError: Bool {
        guard case let DataTransferError.networkFailure(networkError) = self,
            case .notConnected = networkError else {
                return false
        }
        return true
    }
}
