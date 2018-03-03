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
            completedButton.setTitleColor(isEnabled ? .green : .blue, for: .normal)
        }
    }
    
    public func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){(timer) in
            self.timeElapsed += 1
        }
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
        delegate?.startNextTimer(completedComponentIndex: Int(component.index), completedComponentTime: Double(timeElapsed))
    }
}
