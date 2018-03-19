//
//  CompressedComponentView.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/21/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class CompressedComponentView: UIView {
    public func configureView(with component: Component) {
        titleLabel.text = component.name ?? "Unnamed"
        //print("about to set time to \(Int(component.estimatedTimeInMinutes))")
        estimatedTimeLabel.text = "\(Int(component.estimatedTimeInMinutes)) minutes"
    }
    
    lazy private var titleLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Component Name"
        return lab
    }()
    lazy private var estimatedTimeDescriptionLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Estimated Time: "
        return lab
    }()
    lazy private var estimatedTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "0.0"
        return lab
    }()
    lazy private var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        addSubviews()
        configureConstraints()
    }
    private func addSubviews() {
        addSubview(estimatedTimeDescriptionLabel)
        addSubview(estimatedTimeLabel)
        addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true

        estimatedTimeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        estimatedTimeDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        estimatedTimeDescriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        estimatedTimeDescriptionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true

        
        estimatedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        estimatedTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        estimatedTimeLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        estimatedTimeLabel.leadingAnchor.constraint(equalTo: estimatedTimeDescriptionLabel.trailingAnchor, constant: 10).isActive = true        
    }
}
