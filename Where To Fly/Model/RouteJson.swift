//
//  RouteJson.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

struct Operator: Decodable {
    let name: String
}

struct Destination: Decodable {
    let icao: String?
    let iata: String?
    let name: String
    let municipalityName: String?
    let location: Location?
    let countryCode: String?
}

struct RouteJson: Decodable {
    let destination: Destination
    let averageDailyFlights: Double
    let operators: [Operator]
}
