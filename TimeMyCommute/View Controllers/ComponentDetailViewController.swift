//
//  ComponentDetailViewController.swift
//  TimeMyCommute
//
//  Created by C4Q  on 3/19/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

class ComponentDetailViewController: UIViewController {
    let component: Component
    var durations = [Duration]() {
        didSet {
            durationsTableView.reloadData()
        }
    }
    
    lazy var durationsTableView: UITableView = {
        let tb = UITableView()
        tb.delegate = self
        tb.dataSource = self
        let nib = UINib(nibName: "DurationTableViewCell", bundle: nil)
        tb.register(nib, forCellReuseIdentifier: "durationCell")
        return tb
    }()
    
    init(with component: Component) {
        self.component = component
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadData()
        addSubviews()
        configureConstraints()
    }
    func loadData() {
        durations = component.recordedDurations?.allObjects as! [Duration]
    }
    func addSubviews() {
        view.addSubview(durationsTableView)
    }
    func configureConstraints() {
        durationsTableView.translatesAutoresizingMaskIntoConstraints = false
        durationsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        durationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        durationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        durationsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ComponentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return durations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "durationCell", for: indexPath) as! DurationTableViewCell
        cell.configureCell(with: durations[indexPath.row])
        return cell
    }
}
