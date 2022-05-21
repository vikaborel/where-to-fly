//
//  SearchBarView.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class SearchBarView: UIView {
    
    // MARK: - UI Elements
    
    private let searchIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "searchIcon")?.withTintColor(.systemGray4)
        return imageView
    }()
    
    lazy var searchTextField: largerTapAreaTextField = {
        let textField = largerTapAreaTextField()
        textField.attributedPlaceholder = NSAttributedString(string:"4-character ICAO-code", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray4])
        textField.font = UIFont.boldSystemFont(ofSize: 16)
        textField.textColor = .systemGray
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.isOpaque = false
        return textField
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func configureUI() {
        isOpaque = false
        backgroundColor = .white
        layer.cornerRadius = 15
        
        // stroke
        layer.borderWidth = 3
        layer.borderColor = UIColor.systemGray.cgColor
        
        // shadow
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0.3, height: 3.0)
        
        setupSearchTextField()
        setupSearchIconImageView()
    }
    
    private func setupSearchTextField() {
        addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        searchTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupSearchIconImageView() {
        addSubview(searchIconImageView)
        searchIconImageView.translatesAutoresizingMaskIntoConstraints = false
        searchIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        searchIconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        searchIconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchIconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
}
