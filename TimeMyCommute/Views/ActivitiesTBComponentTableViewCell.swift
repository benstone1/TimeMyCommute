//
//  ActivitiesTBComponentTableViewCell.swift
//  TimeMyCommute
//
//  Created by C4Q  on 3/14/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ActivitiesTBComponentTableViewCell: UITableViewCell {
    @IBOutlet weak var componentNameLabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var actualTimeLabel: UILabel!
    func configureCell(with component: Component) {
        componentNameLabel.text = component.name
        estimatedTimeLabel.text = "\(component.estimatedTimeInMinutes)"
        actualTimeLabel.text = component.averageRecordedDuration?.description ?? "No data yet!"
    }
}
