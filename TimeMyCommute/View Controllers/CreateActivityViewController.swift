//
//  CreateActivityViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/8/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController {
    
    @IBOutlet weak var activityNameLabel: UITextField!
    @IBOutlet weak var componenetsTableView: UITableView!
    
    var components = [Component]()
    var unfinishedLastComponent: Component?
    
    var inputComponentIndex = 0 {
        didSet {
            componenetsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponentsTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveActivity))
    }
        
    func configureComponentsTableView() {
        componenetsTableView.dataSource = self
        componenetsTableView.delegate = self
    }
    
    @objc func saveActivity() {
        let activityName = activityNameLabel.text ?? "No name" //TO DO: Validate
        //Add last component if the user didn't already
        let rowNum = componenetsTableView.numberOfRows(inSection: 0)
        if components.count != rowNum {
            let cell = componenetsTableView.cellForRow(at: IndexPath(row: rowNum - 1, section: 0)) as! ComponentTableViewCell
            let lastComponent = cell.getCurrentComponent()
            let alertVC = UIAlertController(title: "Invalid Component", message: "", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            switch lastComponent.validity {
            case .invalidName:
                alertVC.message = "Enter a name or delete the last component"
                present(alertVC, animated: true, completion: nil)
                return
            case .invalidDuration:
                alertVC.message = "Enter an estimated time or delete the last component"
                present(alertVC, animated: true, completion: nil)
                return
            case .valid:
                components.append(lastComponent)
            }
        }
        var activityTimeEstimate: Int16 = 0
        let newActivity = Activity(context: CoreDataHelper.manager.context)
        newActivity.name = activityName
        for (i, c) in components.enumerated() {
            c.index = Int16(i) //Probably not needed
            c.activity = newActivity
            activityTimeEstimate += Int16(c.estimatedTimeInMinutes)
        }
        newActivity.estimatedTimeInMinutes = activityTimeEstimate
        CoreDataHelper.manager.save()
        self.navigationController?.popViewController(animated: true)
    }
}

extension CreateActivityViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "componentCell", for: indexPath) as! ComponentTableViewCell
        cell.delegate = self
        if indexPath.row < components.count {
            let component = components[indexPath.row]
            cell.configureCell(with: component, cellType: indexPath.row == inputComponentIndex ? .input : .compressed, isLastRow: false)
        } else { //Handle last cell
            if let savedUnfinishedComponent = unfinishedLastComponent {
                cell.configureCell(with: savedUnfinishedComponent, cellType: indexPath.row == inputComponentIndex ? .input : .compressed, isLastRow: true)
            } else {
                let newComponent = Component(context: CoreDataHelper.manager.context)
                newComponent.index = Int16(indexPath.row)
                unfinishedLastComponent = newComponent
                cell.configureCell(with: newComponent, cellType: indexPath.row == inputComponentIndex ? .input : .compressed, isLastRow: true)
                cell.resetFields()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard inputComponentIndex != indexPath.row else { return }
        let ip = IndexPath(row: inputComponentIndex, section: 0)
        guard let cell = tableView.cellForRow(at: ip) as? ComponentTableViewCell else { return }
        let alertVC = UIAlertController(title: "Invalid Component", message: "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        switch cell.getCurrentComponent().validity {
        case .valid:
            inputComponentIndex = indexPath.row
            tableView.beginUpdates()
            tableView.endUpdates()
        case .invalidName:
            alertVC.message = "Please enter a valid name"
            present(alertVC, animated: true, completion: nil)
        case .invalidDuration:
            alertVC.message = "Please enter an estimated time"
            present(alertVC, animated: true, completion: nil)
        }
    }
    
    func getUnfinishedComponent() -> Component? {
        let rowNum = componenetsTableView.numberOfRows(inSection: 0)
        if components.count != rowNum {
            let cell = componenetsTableView.cellForRow(at: IndexPath(row: rowNum - 1, section: 0)) as! ComponentTableViewCell
            let lastComponent = cell.getCurrentComponent()
            return lastComponent
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == inputComponentIndex {
            if inputComponentIndex == components.count { return 250 }
            return 200
        } else {
            return 80
        }
    }
}

extension CreateActivityViewController: ComponentTableViewCellDelegate {
    func createNewRow(componentToAppend: Component) {
        components.append(componentToAppend)
        inputComponentIndex += 1
        unfinishedLastComponent = nil
    }
    func moveViewsToAccomadateKeyboard(with keyboardRect: CGRect, cell: ComponentTableViewCell, and duration: Double) {
        let scrollView = componenetsTableView!
        guard keyboardRect != CGRect.zero else {
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
            return
        }
        let hiddenAreaRect = keyboardRect.intersection(scrollView.bounds)
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: hiddenAreaRect.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var textFieldRect = cell.frame
        textFieldRect = scrollView.convert(textFieldRect, from: cell.superview)
        textFieldRect = textFieldRect.insetBy(dx: 0.0, dy: -20)
        scrollView.scrollRectToVisible(textFieldRect, animated: true)
    }
}
