//
//  QueryService.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import Foundation


class QueryService {
    
    // MARK: - Constants
    
    private let twelweHoursInSeconds: Double = 43200
    private let defaultSession = URLSession(configuration: .default)
    private let headers = [
        "x-rapidapi-host": "aerodatabox.p.rapidapi.com",
        "x-rapidapi-key": ""
    ]
    private let decoder = Utilities().configureJSONDecoder(dateFormat: "yyyy-MM-dd HH:mm")
    private let decoderForLocalTime = Utilities().configureJSONDecoder(dateFormat: "yyyy-MM-dd'T'HH:mm")
    
    // MARK: - Variables
    
    var dataTask: URLSessionDataTask?
    var routes: [Route] = []
    var flights: [Flight] = []
    var errorMessage: String?
    
    // MARK: - Typealias
    
    typealias RoutesQueryResponse = ([Route]?, String?) -> Void
    typealias FlightsQueryResponse = ([Flight]?, String?) -> Void
    
    typealias RoutesJson = [String:[RouteJson]]
    typealias FlightsJson = [String:[FlightJson]]
    
    
    // MARK: - Internal Methods
    
    func getRoutes(from icao: String, completion: @escaping RoutesQueryResponse) {
        routes = []
        errorMessage = nil
        
        let request = configureRoutesRequest(with: icao)
        
        fetchData(with: request) {[weak self] (data) in
            if self?.errorMessage == nil {
                self?.updateRoutes(from: icao, with: data) {_,_ in
                    DispatchQueue.main.async { completion(self?.routes, self?.errorMessage)
                    }
                }
            } else {
                DispatchQueue.main.async { completion(self?.routes, self?.errorMessage)
                }
            }
        }}
    
    func getFlights(from originIcao: String, to destinationIcao: String, forPeriod selectedPeriod: Period, localTime: Date, completion: @escaping FlightsQueryResponse) {
        flights = []
        errorMessage = nil
        
        let dispatchGroup = DispatchGroup()
        
        for offset in 0..<(selectedPeriod.rawValue) {
            if errorMessage != nil {
                break
            }
            
            dispatchGroup.enter()
            
            let (startDate, finishDate) = configureRequestsPeriod(currentDate: localTime, offset: Double(offset))
            let request = configureFlightsRequest(with: originIcao, from: startDate, till: finishDate)
            
            fetchData(with: request) { [weak self] (data) in
                if self?.errorMessage == nil {
                self?.updateFlights(from: originIcao, to: destinationIcao, with: data)
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                completion(self.flights, self.errorMessage)
            }
        }
    }
    
    func getLocalTime(icao: String, completion: @escaping (Date) -> Void) -> Date? {
        let request = configureLocalTimeRequest(with: icao)
        let data = fetchLocalTimeData(with: request)
        
        guard let dataReceived = data else { return nil }
        
        let localTime = extractLocalTime(from: dataReceived)
        
        if let localTime = localTime {
        completion(localTime)
        }
        
        return localTime
    }
    
    private func fetchLocalTimeData(with request: URLRequest) -> Data? {
        var dataReceived: Data?
        let semaphore = DispatchSemaphore.init(value: 0)
        
        let dataTask = defaultSession.dataTask(with: request as URLRequest){(data, response, error) in
            defer {
                semaphore.signal()
            }
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            dataReceived = data
        }
        dataTask.resume()
        semaphore.wait()
        
        return dataReceived
    }
    
    private func extractLocalTime(from data: Data) -> Date? {
        let dataDecoded = decode(with: decoderForLocalTime,data: data, into: AirportLocalTimeJson.self)
        
        guard let dataDecodedUnwrapped = dataDecoded else {
            return nil
        }
        return dataDecodedUnwrapped.localTime
    }
    
    // MARK: - Request Helpers
    
    private func configureRoutesRequest(with icao: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://aerodatabox.p.rapidapi.com/airports/icao/\(icao)/stats/routes/daily")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func configureFlightsRequest(with icao: String, from start: String, till finish: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://aerodatabox.p.rapidapi.com/flights/airports/icao/\(icao)/\(start)/\(finish)?withLeg=true&direction=Departure&withCancelled=true&withCodeshared=true&withCargo=false&withPrivate=false&withLocation=false")!,
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func configureLocalTimeRequest(with icao: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://aerodatabox.p.rapidapi.com/airports/icao/\(icao)/time/local")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private func configureRequestsPeriod(currentDate: Date, offset: Double) -> (String, String) {
        let dateFormatter = Utilities().configureDateFormatter(dateFormat: "YYYY-MM-dd'T'HH:mm")
        
        let startDate = currentDate.addingTimeInterval(offset * twelweHoursInSeconds)
        let finishDate = currentDate.addingTimeInterval((offset + 1) * twelweHoursInSeconds)
        
        let startDateString = dateFormatter.string(from: startDate)
        let finishDateString = dateFormatter.string(from: finishDate)
        
        return (startDateString, finishDateString)
    }
    
    // MARK: - Update Functions
    
    private func updateRoutes(from icao: String, with data: Data, completion: @escaping RoutesQueryResponse) {
        let dataDecoded = decode(with: decoder, data: data, into: RoutesJson.self)
        
        guard let dataDecodedUnwrapped = dataDecoded, let routesData = dataDecodedUnwrapped["routes"]  else {
            self.errorMessage = "Data decoding problem occured"
            completion(self.routes, self.errorMessage)
            return
        }
        
        routes = routesData.map{Route.init(originIcao: icao, routeJson: $0)}
        
        completion(self.routes, self.errorMessage)
        
    }
    
    private func updateFlights(from originIcao: String, to destinationIcao: String, with data: Data) {
        let dataDecoded = decode(with: decoder, data: data, into: FlightsJson.self)
        
        guard let dataDecodedUnwrapped = dataDecoded, let departuresData = dataDecodedUnwrapped["departures"] else {
            self.errorMessage = "Data decoding problem occured"
            return
        }
        // не нужен ли тут guard?
        let groupedData = Dictionary(grouping: departuresData) { (flight) -> String in flight.arrival.airport?.icao ?? ""}
        
        let flights = groupedData[destinationIcao]?.map{Flight.init(originIcao: originIcao, flightJson: $0)}
        
        self.flights.append(contentsOf: flights ?? [])
    }
    
    // MARK: - Data Fetcher
    
    private func fetchData(with request: URLRequest, completion: @escaping (Data) -> Void) {
        let dataTask = defaultSession.dataTask(with: request as URLRequest){(data, response, error) in
            if error != nil {
                self.errorMessage = error!.localizedDescription
            } else if let data = data {
                completion(data)
            } else {
                self.errorMessage = "No data returned"
            }
        }
        dataTask.resume()
    }
    
    // MARK: - Decoder
    
    private func decode<T: Decodable>(with decoder: JSONDecoder, data: Data, into type: T.Type) -> T? {
        
        var dataDecoded: T?
        
        do {
            dataDecoded = try decoder.decode(type.self, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        
        return dataDecoded
    }
}


