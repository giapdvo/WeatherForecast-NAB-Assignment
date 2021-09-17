//
//  ForecastQueriesItemCell.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

class ForecastQueriesItemCell: UITableViewCell {

    static let height = CGFloat(50)
    static let reuseIdentifier = String(describing: ForecastQueriesItemCell.self)

    @IBOutlet private var titleLabel: UILabel!
    
    func fill(with suggestion: ForecastQueryListItemViewModel) {
        self.titleLabel.text = suggestion.query
    }

}
