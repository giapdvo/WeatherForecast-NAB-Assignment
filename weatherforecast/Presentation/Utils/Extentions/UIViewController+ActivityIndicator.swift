//
//  UIViewController+ActivityIndicator.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

extension UITableViewController {

    func makeActivityIndicator(size: CGSize) -> UIActivityIndicatorView {
       

        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        
        if #available(iOS 12.0, *) {
            if self.traitCollection.userInterfaceStyle == .dark {
                activityIndicator.color = .white
            } else {
                activityIndicator.color = .gray
            }
        } else {
            activityIndicator.color = .gray
            
        }

        return activityIndicator
    }
}
