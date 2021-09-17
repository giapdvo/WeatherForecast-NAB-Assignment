//
//  ForecastListItemCell.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

class ForecastListItemCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ForecastListItemCell.self)
    static let height = CGFloat(180)
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    private var viewModel: ForecastListItemViewModel!
    private var forecastImagesRepository: ForecastImagesRepository?

    private var imageLoadTask: Cancellable? { willSet { imageLoadTask?.cancel() } }

    func fill(with viewModel: ForecastListItemViewModel, forecastImagesRepository: ForecastImagesRepository?) {
        self.viewModel = viewModel
        self.forecastImagesRepository = forecastImagesRepository
        dateLabel.text = viewModel.date
        temperatureLabel.text = viewModel.temperature
        pressureLabel.text = viewModel.pressure
        humidityLabel.text = viewModel.humidity
        descriptionLabel.text = viewModel.description
        updateWeatherImage()
    }
    
    private func updateWeatherImage() {
        weatherImageView.image = nil
        imageLoadTask = forecastImagesRepository?.fetchImage(with: viewModel.imagePath) { [weak self] result in
            guard let self = self else { return }
            if case let .success(data) = result {
                self.weatherImageView.image = UIImage(data: data)
            }
            self.imageLoadTask = nil
        }
    }

}
