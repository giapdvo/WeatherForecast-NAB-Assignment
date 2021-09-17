//
//  ForecastQueryListItemViewModel.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation

class ForecastQueryListItemViewModel {
    let query: String

    init(query: String) {
        self.query = query
    }
}

extension ForecastQueryListItemViewModel: Equatable {
    static func == (lhs: ForecastQueryListItemViewModel, rhs: ForecastQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}
