//
//  NumberFormatters.swift
//  MTGCards
//
//  Created by Joseph Smith on 4/26/21.
//

import Foundation

extension NumberFormatter {
    convenience init(style: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        numberStyle = style
    }
}
extension Formatter {
    static let currency = NumberFormatter(style: .currency)
    static let currencyUS = NumberFormatter(style: .currency, locale: .us)
    static let currencyBR = NumberFormatter(style: .currency, locale: .br)
}
extension Numeric {   // for Swift 3 use FloatingPoint or Int
    var currency: String {
        return Formatter.currency.string(for: self) ?? ""
    }
    var currencyUS: String {
        return Formatter.currencyUS.string(for: self) ?? ""
    }
    var currencyBR: String {
        return Formatter.currencyBR.string(for: self) ?? ""
    }
}
extension Locale {
    static let br = Locale(identifier: "pt_BR")
    static let us = Locale(identifier: "en_US")
    static let uk = Locale(identifier: "en_UK")
}
