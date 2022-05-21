//
//  LoadingView.swift
//  Where To Fly
//
//  Created Vika Borel
//  April 2022
//

import UIKit

class LoadingView: UIView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let loadingView = configureLoadingView()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse]) {
            loadingView.alpha = 0.7
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Elements Configure & Setup
    
    private func configureLoadingView() -> UIStackView {
        
        let headerView = configureHeaderView()
        let sectionsStack = configureSections()
        
        let loadingView = configureStackView(with: [headerView, sectionsStack], along: .vertical)
        
        addSubview(loadingView)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: topAnchor, constant: 22).isActive = true
        
        return loadingView
    }
    
    private func configureLabelView(ofColor color: UIColor, width: CGFloat, height: CGFloat, ofParentView parentView: UIView) -> UIView {
        
        let view = UIView()
        view.backgroundColor = color
        view.layer.cornerRadius = 5
        
        parentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: width).isActive = true
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return view
    }
    
    private func configureSections() -> UIStackView {
        
        let section1 = configureSectionView(ofColor: .systemPink)
        let section2 = configureSectionView(ofColor: .green)
        let section3 = configureSectionView(ofColor: .systemYellow)
        
        let sectionsStack = configureStackView(with: [section1,
                                                      section2,
                                                      section3],
                                               along: .vertical)
        
        sectionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        return sectionsStack
    }
    
    private func configureSectionView(ofColor color: UIColor) -> UIView {
        
        let sectionView = UIView()
        
        configureSectionContent(ofParentView: sectionView)
        sectionView.translatesAutoresizingMaskIntoConstraints = false
        // подумать, что тут можно сделать с widthAnchor
        sectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return sectionView
    }
    
    private func configureStackView(with elements: [UIView], along axis: NSLayoutConstraint.Axis) -> UIStackView {
        
        let stack = UIStackView(arrangedSubviews: elements)
        stack.axis = axis
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        
        return stack
    }
    
    private func configureSectionContent(ofParentView parentView: UIView) {
        
        let airlineView = configureLabelView(ofColor: .systemGray, width: 50, height: 16, ofParentView: parentView)
        let flightNumberView = configureLabelView(ofColor: .systemGray4, width: 60, height: 16, ofParentView: parentView)
        let timeView = configureLabelView(ofColor: .systemGray4, width: 100, height: 16, ofParentView: parentView)
        let icaoView = configureLabelView(ofColor: .systemGray4, width: 100, height: 16, ofParentView: parentView)
        
        airlineView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 80).isActive = true
        airlineView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 22).isActive = true
        
        flightNumberView.leadingAnchor.constraint(equalTo: airlineView.leadingAnchor).isActive = true
        flightNumberView.topAnchor.constraint(equalTo: airlineView.bottomAnchor, constant: 9).isActive = true
        
        timeView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -80).isActive = true
        timeView.bottomAnchor.constraint(equalTo: airlineView.bottomAnchor).isActive = true
        
        icaoView.trailingAnchor.constraint(equalTo: timeView.trailingAnchor).isActive = true
        icaoView.bottomAnchor.constraint(equalTo: flightNumberView.bottomAnchor).isActive = true
    }
    
    private func configureHeaderView() -> UIView {
        
        let headerView = UIView()
        let headerTitleView = configureLabelView(ofColor: .systemGray6, width: 50, height: 16, ofParentView: headerView)
        
        headerTitleView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 64).isActive = true
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        return headerView
    }
    
}
