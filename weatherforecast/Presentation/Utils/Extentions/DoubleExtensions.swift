//
//  DoubleExtensions.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/16/21.
//

import Foundation

extension Double {
    func toTemperature(unit: UnitTemperature, locale: Locale = Locale(identifier: "en_GB")) -> String {
        let input = Measurement(value: self, unit: unit)
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.roundingMode = .up
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitStyle = .medium
        formatter.locale =  locale
        return formatter.string(from: input)
    }
    
    func getDateStringFromUTC() -> String {
       let date = Date(timeIntervalSince1970: self)

       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US")
       dateFormatter.dateStyle = .full

       return dateFormatter.string(from: date)
    }
}
