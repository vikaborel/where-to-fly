//
//  RoutesViewController.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class RoutesViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    private let feedbackGenerator = UINotificationFeedbackGenerator()
    private let searchBarView = SearchBarView()
    private let spacerView = UIView()
    private let routesTableView = UITableView()
    private var routes: [Route] = []
    private let queryService = QueryService()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        searchBarView.searchTextField.returnKeyType = .search
        searchBarView.searchTextField.delegate = self
        searchBarView.searchTextField.addTarget(self, action: #selector(enterPressed), for: .editingDidEndOnExit)
        
        configureRoutesTableView()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Action Handlers
    
    @objc func showKeyboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchBarView.searchTextField.becomeFirstResponder()
        }
    }
    
    @objc func dismissKeyboard() {
        searchBarView.searchTextField.resignFirstResponder()
    }
    
    @objc func enterPressed() {
        let icao = searchBarView.searchTextField.text?.uppercased() ?? ""
        
        guard icao.isAlpha, icao.count == 4 else {
            animateInputError()
            showKeyboard()
            return
        }
        
        clearTableViewData()
        
        routesTableView.showActivityIndicator()
        updateRoutesTableView(with: icao)
    }
    
    // MARK: - Helpers
    
    private func animateInputError() {
        UIView.animate(withDuration: 0.05, animations: {
            self.searchBarView.frame.origin.x += 10
            self.searchBarView.layer.borderColor = UIColor.systemPink.cgColor
            
        }) { (_) in
            UIView.animate(withDuration: 0.1, delay: 0, animations: {
                self.searchBarView.frame.origin.x -= 20
            }) { (_) in
                UIView.animate(withDuration: 0.05, delay: 0, options: [.curveEaseIn], animations: {
                    self.searchBarView.frame.origin.x += 10
                    self.searchBarView.layer.borderColor = UIColor.systemGray.cgColor
                })
                
            }}
        feedbackGenerator.notificationOccurred(.error)
    }
    
    private func configureRoutesTableView() {
        routesTableView.delegate = self
        routesTableView.dataSource = self
        routesTableView.register(RouteCell.self, forCellReuseIdentifier: RouteCell.identifier)
        
        routesTableView.keyboardDismissMode = .interactive
        
        routesTableView.backgroundColor = .white
        routesTableView.rowHeight = 100
        routesTableView.separatorStyle = .none
    }
    
    private func updateRoutesTableView(with icao: String) {
        queryService.getRoutes(from: icao) { [weak self] routes, errorMessage in
            
            if errorMessage != nil {
                self?.routesTableView.showOverlayView(text: "An error occurred while processing your request")
            } else if let routes = routes, routes.isEmpty == true {
                self?.routesTableView.showOverlayView(text: "No data for this ICAO code")
                self?.showKeyboard()
            }
            else if let routes = routes {
                self?.routes = routes
                self?.routesTableView.reloadData()
                self?.routesTableView.setContentOffset(CGPoint.zero, animated: false)
                self?.routesTableView.hideActivityIndicator()
            }
        }
    }
    
    private func clearTableViewData() {
        routes = []
        routesTableView.reloadData()
        
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RoutesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RouteCell.identifier, for: indexPath) as! RouteCell
        
        let route = routes[indexPath.row]
        cell.configure(route)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let route = routes[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        navigationController?.pushViewController(FlightsViewController.init(route: route), animated: true)
    }
}

// MARK: - UI Setup

extension RoutesViewController {
    
    private func setupUI() {
        setupSearchBar()
        setupRoutesTableView()
    }
    
    private func setupSearchBar() {
        view.addSubview(spacerView)
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        spacerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spacerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        spacerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        spacerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        spacerView.addSubview(searchBarView)
        searchBarView.translatesAutoresizingMaskIntoConstraints = false
        searchBarView.centerYAnchor.constraint(equalTo: spacerView.centerYAnchor).isActive = true
        searchBarView.centerXAnchor.constraint(equalTo: spacerView.centerXAnchor).isActive = true
        searchBarView.widthAnchor.constraint(equalToConstant: 350).isActive = true
        searchBarView.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    private func setupRoutesTableView() {
        
        view.addSubview(routesTableView)
        routesTableView.translatesAutoresizingMaskIntoConstraints = false
        routesTableView.topAnchor.constraint(equalTo: spacerView.bottomAnchor).isActive = true
        routesTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        routesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
