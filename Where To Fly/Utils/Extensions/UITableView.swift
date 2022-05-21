//
//  UITableView.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

extension UITableView {
    
    func showOverlayView(text: String) {
        DispatchQueue.main.async {
            let overlayView = OverlayView()
            overlayView.message.text = text
            self.backgroundView = overlayView
        }
    }
    
    func hideOverlayView() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
    
    func showFlightsLoadingView() {
        DispatchQueue.main.async {
            let activityView = LoadingView()
            self.backgroundView = activityView
        }
    }
    
    func hideFlightsLoadingView() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            let activityView = UIActivityIndicatorView(style: .large)
            self.backgroundView = activityView
            activityView.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.backgroundView = nil
        }
    }
}
