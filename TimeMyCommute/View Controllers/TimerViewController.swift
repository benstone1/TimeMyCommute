//
//  TimerViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/7/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    
    var activities = [Activity]() {
        didSet {
            activityPickerView.reloadComponent(0)
            if activities.isEmpty {
                handleEmptyActivities()
            } else {
                selectedActivity = activities[0]
            }
            startPlayPauseButton.isHidden = activities.isEmpty
            activityPickerView.isHidden = activities.isEmpty
            componentsTableView.isHidden = activities.isEmpty
            emptyStateLabel.isHidden = !activities.isEmpty
        }
    }
    
    var selectedActivity: Activity! {
        didSet {
            components = !activities.isEmpty ? activities[0].sortedComponents : []
        }
    }
    
    var components = [Component]() {
        didSet {
            componentsTableView.reloadData()
        }
    }
    
    var componentTimes = [Double]()
    
    @IBOutlet weak var startPlayPauseButton: UIButton!
    @IBOutlet weak var activityPickerView: UIPickerView!
    @IBOutlet weak var componentsTableView: UITableView!
    
    lazy var emptyStateLabel: UILabel = {
        let lab = UILabel()
        lab.font = UIFont.systemFont(ofSize: 20)
        lab.text = "Add a journey and start timing!"
        return lab
    }()
    
    var activeComponentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsTableView.dataSource = self
        activityPickerView.delegate = self
        activityPickerView.dataSource = self
        componentsTableView.register(UINib(nibName: "TimerTableViewCell", bundle: nil), forCellReuseIdentifier: "componentCell")
        loadActivities()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadActivities()
    }
    
    func loadActivities() {
        activities = CoreDataHelper.manager.allActivities
    }
    
    func handleEmptyActivities() {
        view.addSubview(emptyStateLabel)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        emptyStateLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    @IBAction func playPauseButtonPressed(_ sender: UIButton) {
        activityPickerView.isUserInteractionEnabled = false
        let ip = IndexPath(row: 0, section: 0)
        if let firstCell = componentsTableView.cellForRow(at: ip) as? TimerTableViewCell, activeComponentIndex == 0 {
            firstCell.isEnabled = true
        }
        if sender.titleLabel?.text == "start" || sender.titleLabel?.text == "resume" {
            resumeTimer()
            sender.setTitle("pause", for: .normal)
        }
        if sender.titleLabel?.text == "pause" {
            pauseTimer()
            sender.setTitle("resume", for: .normal)
        }        
    }
    
    func resumeTimer() {
        let ip = IndexPath(row: activeComponentIndex, section: 0)
        if let currentCell = componentsTableView.cellForRow(at: ip) as? TimerTableViewCell {
            currentCell.startTimer()
        }
    }
    func pauseTimer() {
        let ip = IndexPath(row: activeComponentIndex, section: 0)
        if let currentCell = componentsTableView.cellForRow(at: ip) as? TimerTableViewCell {
            currentCell.stopTimer()
        }
    }
    func userDidCompleteActivity() {
        let title = "Save your time?"
        let message = "You have completed timing \(activities[activityPickerView.selectedRow(inComponent: 0)].name!)"
        let avc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveHandler = {(action: UIAlertAction) in
            self.saveActivityComponents()
        }
        avc.addAction(UIAlertAction(title: "Save", style: .default, handler: saveHandler))
        avc.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: nil))
        //avc.addAction(UIAlertAction(title: "Edit times", style: .default, handler: nil)) //TO DO
        present(avc, animated: true){
            self.activityPickerView.isUserInteractionEnabled = true
            self.startPlayPauseButton.setTitle("start", for: .normal)
        }
    }
    
    func saveActivityComponents() {
        for (index, component) in selectedActivity.sortedComponents.enumerated() {
            let newDuration = Duration(context: CoreDataHelper.manager.context)
            newDuration.populate(with: componentTimes[index], in: component)
        }
        CoreDataHelper.manager.save()
    }
}

extension TimerViewController: TimerTableViewCellDelegate {
    func startNextTimer(completedComponentIndex: Int, completedComponentTime: Double) {
        activeComponentIndex += 1
        let nextIndexPath = IndexPath(row: activeComponentIndex, section: 0)
        componentTimes.append(completedComponentTime)
        if let nextCell = componentsTableView.cellForRow(at: nextIndexPath) as? TimerTableViewCell {
            nextCell.startTimer()
            nextCell.isEnabled = true
            startPlayPauseButton.setTitle("pause", for: .normal)
        } else {
            userDidCompleteActivity()
        }
    }
}

extension TimerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as! TimerTableViewCell
        let component = components[indexPath.row]
        cell.configure(with: component)
        cell.delegate = self
        cell.isEnabled = false
        return cell
    }
}

extension TimerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activities.count
    }
}

extension TimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activities[row].name!
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedActivity = activities[row]
        components = activities[row].sortedComponents
    }
}
