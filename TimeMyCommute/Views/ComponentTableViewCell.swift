//
//  ComponentTableViewCell.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/8/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

enum CellType {
    case input
    case compressed
}

protocol ComponentTableViewCellDelegate: class {
    func createNewRow(componentToAppend: Component)
}

class ComponentTableViewCell: UITableViewCell {
    public func configureCell(with component: Component, cellType: CellType, isLastRow: Bool) {
        self.component = component
        changeCellType(to: cellType, isLastRow: isLastRow)
    }
    
    private func changeCellType(to cellType: CellType, isLastRow: Bool) {
        switch cellType {
        case .compressed:
            
            inputComponentView.removeFromSuperview()
            addCompressedViewToHierarchy()
            compressedComponentView.configureView(with: component)
        case .input:
            compressedComponentView.removeFromSuperview()
            addInputViewToHierarchy()
            inputComponentView.configureView(with: component, isLastRow: isLastRow)
        }
    }
    
    private func addCompressedViewToHierarchy() {
        addSubview(compressedComponentView)
        compressedComponentView.translatesAutoresizingMaskIntoConstraints = false
        compressedComponentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        compressedComponentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        compressedComponentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        compressedComponentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func addInputViewToHierarchy() {
        addSubview(inputComponentView)
        inputComponentView.translatesAutoresizingMaskIntoConstraints = false
        inputComponentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        inputComponentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        inputComponentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
        inputComponentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    public func getCurrentComponent() -> Component {
        return self.component
    }

    public var delegate: ComponentTableViewCellDelegate?
    
    private var component: Component!
    
    private var index: Int = 0
    private var currentName: String = ""
    private var currentTime: Double = 0
    
    lazy private var inputComponentView: InputComponentView = {
       let icv = InputComponentView()
        icv.delegate = self
        return icv
    }()
    
    lazy private var compressedComponentView: CompressedComponentView = {
        let ccv = CompressedComponentView()
        return ccv
    }()
}

extension ComponentTableViewCell: InputComponentViewDelegate {
    func timeDidUpdate(to newTime: Double) {
        component.estimatedTimeInMinutes = newTime
    }
    
    func nameDidUpdate(to newName: String) {
        component.name = newName
    }
    
    func addNewComponentButtonPressed() {
        delegate?.createNewRow(componentToAppend: component)
    }
}
