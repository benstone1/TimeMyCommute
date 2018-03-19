//
//  TimerTableViewCell.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/7/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

protocol TimerTableViewCellDelegate: class {
    func startNextTimer(completedComponentIndex: Int, completedComponentTime: Double) -> Void
}

class TimerTableViewCell: UITableViewCell {
    //Public API
    
    weak public var delegate: TimerTableViewCellDelegate?
    
    public func configure(with component: Component) {
        self.component = component
    }
    
    public var isEnabled = false {
        didSet {
            completedButton.isEnabled = isEnabled
            //completedButton.setTitleColor(.blue, for: .normal)
            completedButton.isHidden = !isEnabled
            completedButton.setTitleColor(isEnabled ? .blue : .green, for: .normal)
        }
    }
    
    
    public func startTimer() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleBackgroundMove), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        nc.addObserver(self, selector: #selector(handleForegroundMove), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){(timer) in
            self.timeElapsed += 1
        }
    }
    
    private var backgroundEntranceTime = Date()
    
    @objc private func handleBackgroundMove() {
        backgroundEntranceTime = Date()
    }
    
    @objc private func handleForegroundMove() {
        timeElapsed += Date().timeIntervalSince(backgroundEntranceTime)
    }
    
    public func stopTimer() {
        timer.invalidate()
    }
    
    //Private implementation    
    private var component: Component! {
        didSet {
            componentNameLabel.text = component.name
            timeElapsed = 0
        }
    }
    
    private var timer = Timer()
    
    private var timeElapsed: TimeInterval = 0 {
        didSet {
            self.timerLabel.text = DateHelper.manager.getFormattedTime(from: timeElapsed)
        }
    }
    
    @IBOutlet weak private var componentNameLabel: UILabel!
    @IBOutlet weak private var timerLabel: UILabel!
    @IBOutlet weak private var completedButton: UIButton!
    
    @IBAction private func completedButtonPressed(_ sender: Any) {
        stopTimer()
        isEnabled = false
        completedButton.isHidden = false
        delegate?.startNextTimer(completedComponentIndex: Int(component.index), completedComponentTime: Double(timeElapsed))
    }
}
