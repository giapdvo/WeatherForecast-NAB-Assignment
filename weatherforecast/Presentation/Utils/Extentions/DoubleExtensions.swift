//
//  DoubleExtensions.swift
//  weatherforecast
//
//  Created by Giap Vo on 9/16/21.
//

import Foundation

extension Double {
    func toTemperature(unit: UnitTemperature, locale: Locale = Locale(identifier: "en_US")) -> String {
        let input = Measurement(value: self, unit: unit)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.locale =  locale
        return formatter.string(from: input)
    }
    
    func getDateStringFromUTC() -> String {
       let date = Date(timeIntervalSince1970: self)

       let dateFormatter = DateFormatter()
       dateFormatter.locale = Locale(identifier: "en_US")
       dateFormatter.dateStyle = .medium

       return dateFormatter.string(from: date)
    }
}
