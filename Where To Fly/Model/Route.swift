//
//  Route.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation

struct Route {
    let originIcao: String
    let destinationIcao: String
    let destinationName: String
    let averageDailyFlights: Double
    
    init(originIcao: String, routeJson: RouteJson) {
        self.originIcao = originIcao
        
        self.destinationIcao = routeJson.destination.icao ?? "None"
        let municipalityName = routeJson.destination.municipalityName ?? routeJson.destination.name
        let countryCode = routeJson.destination.countryCode ?? "None"
        self.destinationName =  "\(municipalityName), \(countryCode)"
        self.averageDailyFlights = routeJson.averageDailyFlights
    }
}
