//
//  DurationTableViewCell.swift
//  TimeMyCommute
//
//  Created by C4Q  on 3/19/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class DurationTableViewCell: UITableViewCell {
    public func configureCell(with duration: Duration) {
        timeLabel.text = "\(duration.minutes) minutes"
        dateLabel.text = "\(duration.dateRecorded?.description ?? "n/a")"
    }
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
}
