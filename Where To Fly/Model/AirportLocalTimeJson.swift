//
//  AirportLocalTimeJson.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

struct AirportLocalTimeJson: Decodable {
    let utcTime: String
    let localTime: Date
}
