//
//  OverlayView.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class OverlayView: UIView {
    
    // MARK: - UI Elements
    
    let message = Utilities().configureLabel(
        textColor: .systemGray4,
        fontSize: 18,
        fontWeight: .medium,
        multipleLinesAllowed: true
    )
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func configureUI() {
        backgroundColor = .white
        
        addSubview(message)
        message.translatesAutoresizingMaskIntoConstraints = false
        message.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        message.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        message.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}
