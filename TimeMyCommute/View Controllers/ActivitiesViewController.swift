//
//  ActivitiesViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/11/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

struct ActivityWrapper {
    let activity: Activity
    var shouldCompress: Bool = true
    init(activity: Activity) {
        self.activity = activity
    }
}

class ActivitiesViewController: UIViewController {

    var activities = [ActivityWrapper]()
    
    @IBOutlet weak var activitiesTableView: UITableView!
    
    lazy var emptyStateLabel: UILabel = {
        let lab = UILabel()
        lab.text = "Add a journey to get started!"
        lab.font = UIFont.systemFont(ofSize: 20)
        return lab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadActivities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadActivities()
    }
    
    func configureTableView() {
        activitiesTableView.dataSource = self
        activitiesTableView.delegate = self
        activitiesTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        activitiesTableView.estimatedSectionHeaderHeight = 200;
        let cellNib = UINib(nibName: "ActivitiesTBComponentTableViewCell", bundle: nil)
        activitiesTableView.register(cellNib, forCellReuseIdentifier: "componentCell")
    }
    
    func loadActivities() {
        activities = CoreDataHelper.manager.allActivities.map{ActivityWrapper(activity: $0)}
        if activities.isEmpty {
            setEmptyState()
        } else {
            activitiesTableView.reloadData()
        }
        activitiesTableView.isHidden = activities.isEmpty
        emptyStateLabel.isHidden = !activities.isEmpty
    }
    
    func setEmptyState() {
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateLabel)
        emptyStateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ActivityDetailViewController {
            destination.activity = activities[activitiesTableView.indexPathForSelectedRow!.row].activity
        }
    }
}

extension ActivitiesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  activities[section].shouldCompress ? 0 : (activities[section].activity.components?.count ?? 0)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as! ActivitiesTBComponentTableViewCell
        let activity = activities[indexPath.section].activity
        let component = activity.sortedComponents[indexPath.row]
        cell.configureCell(with: component)
        return cell
    }
}

extension ActivitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ActivityTableViewHeaderView(activity: activities[section].activity)
        headerView.delegate = self
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedComponent = activities[indexPath.section].activity.sortedComponents[indexPath.row]
        let componentDetailVC = ComponentDetailViewController(with: selectedComponent)
        self.navigationController?.pushViewController(componentDetailVC, animated: true)
    }
}

extension ActivitiesViewController: ActivityTableHeaderViewDelegate {
    func viewWasTapped(with activity: Activity) {
        if let index = activities.index(where: {$0.activity === activity}) {
            activities[index].shouldCompress = !(activities[index].shouldCompress)
            let selectedIndex = IndexSet(integer: index)
            activitiesTableView.reloadSections(selectedIndex, with: .automatic)
        }
    }
    func viewWasLongPressed(with activity: Activity) {
        if let index = activities.index(where: {$0.activity === activity}) {
            let selectedActivity = activities[index].activity
            let alertAS = UIAlertController(title: "Warning", message: "You are about to delete \(selectedActivity.name ?? "Unknown Name") and all its associated data.  This cannot be reversed", preferredStyle: .actionSheet)
            alertAS.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertAS.addAction(UIAlertAction(title: "Delete", style: .destructive){_ in
                CoreDataHelper.manager.context.delete(selectedActivity)
                CoreDataHelper.manager.save()
                self.activities.remove(at: index)
                self.activitiesTableView.deleteSections(IndexSet(integer: index), with: .automatic)
            })
            present(alertAS, animated: true, completion: nil)
        }
    }
}
