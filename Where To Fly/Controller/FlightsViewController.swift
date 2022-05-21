//
//  FlightsViewController.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class FlightsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let route: Route
    private var localTime: Date?
    private var flights: [Flight] = []
    private var groups:[Date:[Flight]] = [:]
    private var sections:[DaySection] = []
    
    struct DaySection {
        var date: Date
        var flights: [Flight]
    }
    
    private let flightsTableView = UITableView()
    private let queryService = QueryService()
    
    private var selectedPeriod = Period.oneDay
    
    // MARK: - UI Elements
    
    let destinationNameLabel = Utilities().configureLabel(
        textColor: .darkGray,
        fontSize: 32,
        fontWeight: .semibold,
        textAlignment: .right
    )
    let destinationIcaoLabel = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 16,
        fontWeight: .semibold
    )
    let localTimeLabel = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 14,
        fontWeight: .regular
    )
    
    let timePeriodControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["24hrs", "3 days", "7 days"])
        control.selectedSegmentIndex = 0
        return control
    }()
    
    // MARK: - Initializers
    
    init(route: Route) {
        self.route = route
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.tintColor = UIColor.darkGray
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.localTime = queryService.getLocalTime(icao: route.originIcao) { date in
            self.setupLocalTimeLabel(with: date)
        }
        
        guard self.localTime != nil else {
            flightsTableView.showOverlayView(text: "Error occured attempting to get the local time. Please, try again later")
            return }
        
        updateFlightsTableView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureFlightsTableView()
        
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
        timePeriodControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        setupUI()
        flightsTableView.showFlightsLoadingView()
    }
    
    // MARK: - Action Handlers
    
    @objc func popToPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        guard self.localTime != nil else {
            flightsTableView.showOverlayView(text: "Error occured attempting to get the local time. Please, try again later")
            return }
        
        clearTableViewData()
        flightsTableView.showFlightsLoadingView()
        
        if timePeriodControl.selectedSegmentIndex == 0 {
            selectedPeriod = Period.oneDay
        } else if timePeriodControl.selectedSegmentIndex == 1 {
            selectedPeriod = Period.threeDays
        } else if timePeriodControl.selectedSegmentIndex == 2 {
            selectedPeriod = Period.sevenDays
        }
        
        updateFlightsTableView()
    }
    
    // MARK: - Helpers
    
    private func configureFlightsTableView() {
        flightsTableView.delegate = self
        flightsTableView.dataSource = self
        
        flightsTableView.register(FlightCell.self, forCellReuseIdentifier: FlightCell.identifier)
        
        flightsTableView.rowHeight = 80
        flightsTableView.separatorStyle = .none
    }
    
    private func updateFlightsTableView() {
        queryService.getFlights(from: route.originIcao, to: route.destinationIcao, forPeriod: selectedPeriod, localTime: localTime!) {
            [weak self] flights, errorMessage in
            if errorMessage != nil {
                self?.flightsTableView.showOverlayView(text: "An error occurred while processing your request")
            } else if let flights = flights, flights.isEmpty == true {
                self?.flightsTableView.showOverlayView(text: "No data for this time period") }
            else if let flights = flights {
                self?.flights = flights
                self?.populateTableSections()
                self?.flightsTableView.reloadData()
                self?.flightsTableView.hideFlightsLoadingView()
                self?.flightsTableView.setContentOffset(CGPoint.zero, animated: false)
            }
        }
    }
    
    private func clearTableViewData() {
        flights = []
        sections.removeAll()
        flightsTableView.reloadData()
        
    }
}

// MARK: - TableView Sections Setup

extension FlightsViewController {
    
    private func populateTableSections() {
        groups = groupFlightsByDate(flights)
        sections = configureSections(groups: groups)
        sections.sort { (lhs, rhs) in lhs.date < rhs.date }
    }
    
    private func configureSections(groups: (Dictionary<Date, Array<Flight>>)) -> [DaySection] {
        return groups.map { (key, values) in
            return DaySection(date: key, flights: values)
        }
    }
    
    private func groupFlightsByDate(_ array: [Flight]) -> [Date:[Flight]] {
        return Dictionary(grouping: array) { (flight) in
            return extractDayAndMonth(from: flight.departureTime)
        }
    }
    
    private func extractDayAndMonth(from date: Date) -> Date {
        var calender = Calendar.current
        calender.timeZone = TimeZone.init(secondsFromGMT: 0)!
        let components = calender.dateComponents([.month, .day], from: date)
        return calender.date(from: components)!
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension FlightsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = sections[section]
        let date = section.date
        let dateFormatter = Utilities().configureDateFormatter(dateFormat: "LLLL d")
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let section = sections[section]
        return section.flights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = flightsTableView.dequeueReusableCell(withIdentifier: FlightCell.identifier, for: indexPath) as! FlightCell
        
        let section = sections[indexPath.section]
        let flight = section.flights[indexPath.row]
        
        cell.configure(flight)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let label = UILabel()
        label.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray2
        label.text = self.tableView(flightsTableView, titleForHeaderInSection: section)

        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.layer.opacity = 0.9
        headerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 64).isActive = true

        return headerView
    }
}

// MARK: - UI Setup

extension FlightsViewController {
    
    private func setupUI() {
        setupDestinationLabel()
        setupTimePeriodControl()
        setupTableView()
    }
    // сделать все это private, наверное
    private func setupDestinationLabel() {
        destinationNameLabel.text = route.destinationName
        
        view.addSubview(destinationNameLabel)
        destinationNameLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        destinationNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        destinationNameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        destinationIcaoLabel.text = route.destinationIcao
        
        view.addSubview(destinationIcaoLabel)
        destinationIcaoLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationIcaoLabel.topAnchor.constraint(equalTo: destinationNameLabel.bottomAnchor, constant: 3).isActive = true
        destinationIcaoLabel.trailingAnchor.constraint(equalTo: destinationNameLabel.trailingAnchor, constant: -3).isActive = true
    }
    
    private func setupTimePeriodControl() {
        view.addSubview(timePeriodControl)
        timePeriodControl.translatesAutoresizingMaskIntoConstraints = false
        timePeriodControl.topAnchor.constraint(equalTo: destinationNameLabel.bottomAnchor, constant: 40).isActive = true
        timePeriodControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        timePeriodControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func setupTableView() {
        flightsTableView.backgroundColor = .white
        
        view.addSubview(flightsTableView)
        flightsTableView.translatesAutoresizingMaskIntoConstraints = false
        flightsTableView.topAnchor.constraint(equalTo: timePeriodControl.bottomAnchor, constant: 22).isActive = true
        flightsTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        flightsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupLocalTimeLabel(with date: Date) {
        
        let dateFormatter = Utilities().configureDateFormatter(dateFormat: "MMM d, HH:mm")
        let localTime = dateFormatter.string(from: date)
        
        localTimeLabel.text = "\(route.originIcao) local time: \(localTime)"
        view.addSubview(localTimeLabel)
        localTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        localTimeLabel.topAnchor.constraint(equalTo: timePeriodControl.bottomAnchor, constant: 10).isActive = true
        localTimeLabel.centerXAnchor.constraint(equalTo: timePeriodControl.centerXAnchor).isActive = true
        
    }
}
