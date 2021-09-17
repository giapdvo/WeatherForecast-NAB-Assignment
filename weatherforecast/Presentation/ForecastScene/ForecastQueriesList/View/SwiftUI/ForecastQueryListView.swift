//
//  ForecastQueryListView.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation
import SwiftUI

@available(iOS 13.0, *)
extension ForecastQueryListItemViewModel: Identifiable { }

@available(iOS 13.0, *)
struct ForecastQueryListView: View {
    @ObservedObject var viewModelWrapper: ForecastQueryListViewModelWrapper
    
    var body: some View {
        List(viewModelWrapper.items) { item in
            Button(action: {
                self.viewModelWrapper.viewModel?.didSelect(item: item)
            }) {
                Text(item.query)
            }
        }
        .onAppear {
            self.viewModelWrapper.viewModel?.viewWillAppear()
        }
    }
}

@available(iOS 13.0, *)
final class ForecastQueryListViewModelWrapper: ObservableObject {
    var viewModel: ForecastQueryListViewModel?
    @Published var items: [ForecastQueryListItemViewModel] = []
    
    init(viewModel: ForecastQueryListViewModel?) {
        self.viewModel = viewModel
        viewModel?.items.observe(on: self) { [weak self] values in self?.items = values }
    }
}

#if DEBUG
@available(iOS 13.0, *)
struct ForecastQueryListView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastQueryListView(viewModelWrapper: previewViewModelWrapper)
    }
    
    static var previewViewModelWrapper: ForecastQueryListViewModelWrapper = {
        var viewModel = ForecastQueryListViewModelWrapper(viewModel: nil)
        viewModel.items = [ForecastQueryListItemViewModel(query: "item 4"),
                           ForecastQueryListItemViewModel(query: "item 2")
        ]
        return viewModel
    }()
}
#endif
