//
//  ActivityTableViewHeaderView.swift
//  TimeMyCommute
//
//  Created by C4Q  on 3/14/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

protocol ActivityTableHeaderViewDelegate: class {
    func viewWasTapped(with activity: Activity)
    func viewWasLongPressed(with: Activity)
}

class ActivityTableViewHeaderView: UIView {
    init(activity: Activity) {
        self.activity = activity
        super.init(frame: CGRect.zero)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let activity: Activity
    weak var delegate: ActivityTableHeaderViewDelegate?
    
    private lazy var activityNameLabel: UILabel = {
        let lab = UILabel()
        lab.text = activity.name
        return lab
    }()
    private lazy var activityEstimatedTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Estimated Time: \(activity.estimatedTimeInMinutes) minutes"
        return lab
    }()
    private lazy var activityActualTimeLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Actual Time: \(activity.averageRecordedTimeInMinutes?.description ?? "n/a") minutes"
        return lab
    }()
    private func commonInit() {
        addSubviews()
        configureConstraints()
        backgroundColor = .red
        configureTapRecognizer()
        configureLongPressRecognizer()
    }
    private func addSubviews() {
        addSubview(activityNameLabel)
        addSubview(activityEstimatedTimeLabel)
        addSubview(activityActualTimeLabel)
    }
    private func configureConstraints() {
        setupActivityNameLabel()
        setupEstimatedTimeLabel()
        setupActualTimeLabel()
    }
    private func setupActivityNameLabel() {
        activityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        activityNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        activityNameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        activityNameLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    private func setupEstimatedTimeLabel() {
        activityEstimatedTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        activityEstimatedTimeLabel.topAnchor.constraint(equalTo: activityNameLabel.bottomAnchor, constant: 8).isActive = true
        activityEstimatedTimeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        activityEstimatedTimeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
    }
    private func setupActualTimeLabel() {
        activityActualTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        activityActualTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        activityActualTimeLabel.topAnchor.constraint(equalTo: activityEstimatedTimeLabel.bottomAnchor, constant: 8).isActive = true
        activityActualTimeLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
        activityActualTimeLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        activityActualTimeLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    private func configureTapRecognizer() {
        let tapRecog = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapRecog)
    }
    private func configureLongPressRecognizer() {
        let lpRecog = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        addGestureRecognizer(lpRecog)
    }
    
    @objc private func handleLongPress() {
        delegate?.viewWasLongPressed(with: activity)
    }
    @objc private func handleTap() {
        delegate?.viewWasTapped(with: activity)
    }
}
