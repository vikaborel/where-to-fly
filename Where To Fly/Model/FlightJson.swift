//
//  Flight.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

struct Image: Decodable {
    let url: String?
    let webUrl: String?
    let author: String?
    let title: String?
    let description: String?
    let license: String?
    let htmlAttributions: [String]?
}

struct Location: Decodable {
    let lat: Double?
    let lon: Double?
}

struct Airline: Decodable {
    let name: String
}

struct Aircraft: Decodable {
    let reg: String?
    let modeS: String?
    let model: String?
    let image: Image?
}

struct Airport: Decodable {
    let icao: String?
    let iata: String?
    let localCode: String?
    let name: String
    let shortName: String?
    let municipalityName: String?
    let location: Location?
    let countryCode: String?
}

struct Arrival: Decodable {
    let airport: Airport?
    let scheduledTimeLocal: Date?
    let actualTimeLocal: String?
    let runwayTimeLocal: String?
    let scheduledTimeUtc: String?
    let actualTimeUtc: String?
    let runwayTimeUtc: String?
    let terminal: String?
    let checkInDesk: String?
    let gate: String?
    let baggageBelt: String?
    let runaway: String?
    let quality: [String]
}

struct Departure: Decodable {
    let airport: Airport?
    let scheduledTimeLocal: Date?
    let actualTimeLocal: String?
    let runwayTimeLocal: String?
    let scheduledTimeUtc: String?
    let actualTimeUtc: String?
    let runwayTimeUtc: String?
    let terminal: String?
    let checkInDesk: String?
    let gate: String?
    let baggageBelt: String?
    let runaway: String?
    let quality: [String]
}

struct FlightJson: Decodable {
    let departure: Departure
    let arrival: Arrival
    let number: String
    let callSign: String?
    let status: String
    let codeshareStatus: String
    let isCargo: Bool
    let aircraft: Aircraft?
    let airline: Airline?
}
