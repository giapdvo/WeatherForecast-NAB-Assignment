//
//  ForecastQueriesTableViewController.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

class ForecastQueriesTableViewController: UITableViewController, StoryboardInstantiable {
    
    private var viewModel: ForecastQueryListViewModel!
    
    
    //MARK: - Lifecycle
    
    static func create(with viewModel: ForecastQueryListViewModel) -> ForecastQueriesTableViewController {
        let view = ForecastQueriesTableViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    private func bind(to viewModel: ForecastQueryListViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.tableView.reloadData() }
    }
    
    
    // MARK: - Private

    private func setupViews() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = ForecastQueriesItemCell.height
        tableView.rowHeight = UITableView.automaticDimension
    }

}


// MARK: - UITableViewDataSource, UITableViewDelegate

extension ForecastQueriesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastQueriesItemCell.reuseIdentifier, for: indexPath) as? ForecastQueriesItemCell else {
            assertionFailure("Cannot dequeue reusable cell \(ForecastQueriesItemCell.self) with reuseIdentifier: \(ForecastQueriesItemCell.reuseIdentifier)")
            return UITableViewCell()
        }
        cell.fill(with: viewModel.items.value[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didSelect(item: viewModel.items.value[indexPath.row])
    }
}
