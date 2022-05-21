//
//  RouteCell.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//


import UIKit

class RouteCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RouteCell"

    // MARK: - UI Elements
    
    private let destinationLabel = Utilities().configureLabel(
        textColor: .gray,
        fontSize: 22,
        fontWeight: .semibold
    )
    private let destinationIcaoLabel = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 16,
        fontWeight: .semibold
    )
    private let numberOfFlightsLabel = Utilities().configureLabel(
        textColor: .systemGray,
        fontSize: 16,
        fontWeight: .semibold
    )
    
    private let customCellSeparator: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = .systemGray6
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    // MARK: - Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal Methods
    
    func configure(_ route: Route) {
        destinationLabel.text = route.destinationName
        destinationIcaoLabel.text = route.destinationIcao
        numberOfFlightsLabel.text = "~ " + String(route.averageDailyFlights) + " flights daily"
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        setupDestinationLabel()
        setupDestinationIcaoLabel()
        setupNumberOfFlightsLabel()
        setupCustomCellSeparator()
    }
    
    private func setupDestinationLabel() {
        addSubview(destinationLabel)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        destinationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 54).isActive = true
        destinationLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupDestinationIcaoLabel() {
        addSubview(destinationIcaoLabel)
        destinationIcaoLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationIcaoLabel.topAnchor.constraint(equalTo: destinationLabel.bottomAnchor, constant: 3).isActive = true
        destinationIcaoLabel.leadingAnchor.constraint(equalTo: destinationLabel.leadingAnchor).isActive = true
    }
    
    private func setupNumberOfFlightsLabel() {
        addSubview(numberOfFlightsLabel)
        numberOfFlightsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfFlightsLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        numberOfFlightsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -54).isActive = true
    }
    
    private func setupCustomCellSeparator() {
        addSubview(customCellSeparator)
        customCellSeparator.widthAnchor.constraint(equalToConstant: 300).isActive = true
        customCellSeparator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        customCellSeparator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        customCellSeparator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
