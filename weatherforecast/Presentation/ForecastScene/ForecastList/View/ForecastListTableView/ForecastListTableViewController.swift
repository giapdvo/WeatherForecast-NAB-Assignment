//
//  ForecastListTableViewController.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

class ForecastListTableViewController: UITableViewController {
    
    var viewModel: ForecastListViewModel!
    var forecastImagesRepository: ForecastImagesRepository?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func reload() {
        tableView.reloadData()
    }
    
    // MARK: - Private
    private func setupViews() {
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

   

}

extension ForecastListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastListItemCell.reuseIdentifier,
                                                       for: indexPath) as? ForecastListItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(ForecastListItemCell.self) with reuseIdentifier: \(ForecastListItemCell.reuseIdentifier)")
            return UITableViewCell()
        }

        cell.fill(with: viewModel.items.value[indexPath.row], forecastImagesRepository: forecastImagesRepository)


        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.isEmpty ? tableView.frame.height : super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}
