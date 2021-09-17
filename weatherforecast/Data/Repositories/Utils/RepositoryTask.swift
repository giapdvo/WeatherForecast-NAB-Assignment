//
//  RepositoryTask.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/14/21.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
