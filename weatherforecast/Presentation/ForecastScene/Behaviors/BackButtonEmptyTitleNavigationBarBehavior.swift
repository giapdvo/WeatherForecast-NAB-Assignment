//
//  BackButtonEmptyTitleNavigationBarBehavior.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import UIKit

struct BackButtonEmptyTitleNavigationBarBehavior: ViewControllerLifecycleBehavior {

    func viewDidLoad(viewController: UIViewController) {

        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
