//
//  CGSize+ScaledSize.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/15/21.
//

import Foundation
import UIKit

extension CGSize {
    var scaledSize: CGSize {
        .init(width: width * UIScreen.main.scale, height: height * UIScreen.main.scale)
    }
}
