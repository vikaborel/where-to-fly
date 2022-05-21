//
//  Flight.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

struct Flight {
    let airline: String
    let number: String
    let originIcao: String
    let destinationIcao: String
    let departureTime: Date
    let arrivalTime: Date
    
    init(originIcao: String, flightJson: FlightJson) {
        self.originIcao = originIcao
        
        self.airline = flightJson.airline?.name ?? "None"
        self.number = flightJson.number
        self.destinationIcao = flightJson.arrival.airport?.icao ?? "None"
        self.departureTime = flightJson.departure.scheduledTimeLocal ?? Date()
        self.arrivalTime = flightJson.arrival.scheduledTimeLocal ?? Date()
    }
    
}
