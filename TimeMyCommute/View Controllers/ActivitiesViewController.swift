//
//  ActivitiesViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {

    var activities = [Activity]()
    
    @IBOutlet weak var activitiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitiesTableView.dataSource = self
        activitiesTableView.delegate = self
        loadActivities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadActivities()
    }
    
    func loadActivities() {
        activities = CoreDataHelper.manager.allActivities
        activitiesTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActivityDetailViewController {
            destination.activity = activities[activitiesTableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activity = activities[indexPath.row]
        cell.textLabel?.text = activity.name
        return cell
    }
}

extension ActivitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let selectedActivity = activities[indexPath.row]
            let alertVC = UIAlertController(title: "Warning", message: "You are about to delete \(selectedActivity.name ?? "Unknown Name") and all its associated data.  This cannot be reversed", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Delete", style: .destructive){_ in
                CoreDataHelper.manager.context.delete(selectedActivity)
                CoreDataHelper.manager.save()
                self.activities.remove(at: indexPath.row)
                self.activitiesTableView.deleteRows(at: [indexPath], with: .automatic)
            })
            present(alertVC, animated: true, completion: nil)
        }
    }
}
