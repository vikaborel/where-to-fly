//
//  String.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

extension String {
    
    var isAlpha: Bool {
        return !isEmpty && range(of: "[^A-Za-z]", options: .regularExpression) == nil
    }
}
