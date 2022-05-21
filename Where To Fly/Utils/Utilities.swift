//
//  Utilities.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation
import UIKit

class Utilities {
    
    func configureJSONDecoder(dateFormat: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let data = try decoder.singleValueContainer().decode(String.self)
            let formatter = self.configureDateFormatter(dateFormat: dateFormat)
            return formatter.date(from: String(data.prefix(16))) ?? Date()
        })
        return decoder
    }
    
    func configureDateFormatter(dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
    
    func configureLabel(textColor: UIColor, fontSize: CGFloat, fontWeight: UIFont.Weight, textAlignment: NSTextAlignment = .natural, multipleLinesAllowed: Bool = false) -> UILabel {
        let label = UILabel()
        label.textColor = textColor
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        if multipleLinesAllowed {
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            label.textAlignment = .center
        } else {
            label.textAlignment = textAlignment
        }
        return label
    }
}
