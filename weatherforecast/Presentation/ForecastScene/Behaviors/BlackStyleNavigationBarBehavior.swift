//
//  BlackStyleNavigationBarBehavior.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

struct BlackStyleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationController?.navigationBar.barStyle = .black
    }
}
