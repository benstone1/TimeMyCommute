//
//  ActivityDetailViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {

    var activity: Activity!
    
    @IBOutlet weak var componentsTableView: UITableView!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var averageTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupLabels()
    }
    func configureTableView() {
        componentsTableView.dataSource = self
        componentsTableView.delegate = self
        componentsTableView.reloadData()
    }
    func setupLabels() {
        estimatedTimeLabel.text = "Est. time: \(activity.estimatedTimeInMinutes)"
        averageTimeLabel.text = "Avg. time: \(activity.averageRecordedTime?.description ?? "no data yet")"
    }
}

extension ActivityDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activity.sortedComponents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath)
        let component = activity.sortedComponents[indexPath.row]
        cell.textLabel?.text = component.name ?? "no name"
        cell.detailTextLabel?.text = "Est: \(component.estimatedTimeInMinutes), Actual: \(component.averageRecordedDuration?.description ?? "No data yet")"
        return cell
    }
}


