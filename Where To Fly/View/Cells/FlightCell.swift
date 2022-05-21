//
//  FlightCell.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class FlightCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FlightCell"
    
    private let dateFormatter = Utilities().configureDateFormatter(dateFormat: "HH:mm")
    
    // MARK: - UI Elements
    
    private let airlineLabel = Utilities().configureLabel(
        textColor: .darkGray,
        fontSize: 20,
        fontWeight: .semibold
    )
    private let flightNumberLabel = Utilities().configureLabel(
        textColor: .systemGray,
        fontSize: 18,
        fontWeight: .medium
    )
    private let departureTimeLabel = Utilities().configureLabel(
        textColor: .darkGray,
        fontSize: 16,
        fontWeight: .regular
    )
    private let arrivalTimeLabel = Utilities().configureLabel(
        textColor: .darkGray,
        fontSize: 16,
        fontWeight: .regular
    )
    private let separatorLabel = Utilities().configureLabel(
        textColor: .darkGray,
        fontSize: 18,
        fontWeight: .regular
    )
    private let departureIcaoLabel = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 18,
        fontWeight: .semibold
    )
    private let arrivalIcaoLabel = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 18,
        fontWeight: .semibold
    )
    
    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(_ flight: Flight) {
        airlineLabel.text = flight.airline
        flightNumberLabel.text = flight.number
        departureTimeLabel.text = dateFormatter.string(from: flight.departureTime)
        arrivalTimeLabel.text = dateFormatter.string(from: flight.arrivalTime)
        departureIcaoLabel.text = flight.originIcao
        arrivalIcaoLabel.text = flight.destinationIcao
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        setupAirlineLabel()
        setupFlightNumberLabel()
        setupArrivalTimeLabel()
        setupSeparatorLabel()
        setupDepartureTimeLabel()
        setupDepartureIcaoLabel()
        setupArrivalIcaoLabel()
    }
    
    private func setupAirlineLabel() {
        addSubview(airlineLabel)
        airlineLabel.translatesAutoresizingMaskIntoConstraints = false
        airlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80).isActive = true
        airlineLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        airlineLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    private func setupFlightNumberLabel() {
        addSubview(flightNumberLabel)
        flightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        flightNumberLabel.leadingAnchor.constraint(equalTo: airlineLabel.leadingAnchor).isActive = true
        flightNumberLabel.topAnchor.constraint(equalTo: airlineLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    private func setupArrivalTimeLabel() {
        addSubview(arrivalTimeLabel)
        arrivalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        arrivalTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80).isActive = true
        arrivalTimeLabel.bottomAnchor.constraint(equalTo: airlineLabel.bottomAnchor).isActive = true
    }
    
    private func setupSeparatorLabel() {
        addSubview(separatorLabel)
        separatorLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -130).isActive = true
        separatorLabel.bottomAnchor.constraint(equalTo: airlineLabel.bottomAnchor).isActive = true
    }
    
    private func setupDepartureTimeLabel() {
        addSubview(departureTimeLabel)
        departureTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        departureTimeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -148).isActive = true
        departureTimeLabel.bottomAnchor.constraint(equalTo: arrivalTimeLabel.bottomAnchor).isActive = true
    }
    
    private func setupDepartureIcaoLabel() {
        addSubview(departureIcaoLabel)
        departureIcaoLabel.translatesAutoresizingMaskIntoConstraints = false
        departureIcaoLabel.trailingAnchor.constraint(equalTo: departureTimeLabel.trailingAnchor).isActive = true
        departureIcaoLabel.bottomAnchor.constraint(equalTo: flightNumberLabel.bottomAnchor).isActive = true
    }
    
    private func setupArrivalIcaoLabel() {
        addSubview(arrivalIcaoLabel)
        arrivalIcaoLabel.translatesAutoresizingMaskIntoConstraints = false
        arrivalIcaoLabel.trailingAnchor.constraint(equalTo: arrivalTimeLabel.trailingAnchor).isActive = true
        arrivalIcaoLabel.bottomAnchor.constraint(equalTo: flightNumberLabel.bottomAnchor).isActive = true
    }

}
