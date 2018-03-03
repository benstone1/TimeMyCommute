//
//  InputComponentTableViewCell.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/17/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

/*
class InputComponentTableViewCell: UITableViewCell {
    weak public var delegate: ComponentTableViewCellDelegate?
    
    public func configureCell(at indexPath: IndexPath, isLastRow: Bool = true) {
        index = indexPath.row
        addNewComponentButton.isHidden = !isLastRow
    }
    
    private var index: Int = 0
    
    @IBOutlet private weak var timeSlider: UISlider!
    @IBOutlet private weak var componentNameTextField: UITextField!
    @IBOutlet private weak var timeTextField: UITextField!
    @IBOutlet private weak var addNewComponentButton: UIButton!
    
    private var currentTime: Float = 0 {
        didSet {
            timeSlider.value = currentTime
            timeTextField.text = "\(currentTime)"
        }
    }
    @IBAction private func sliderValueChanged(_ sender: UISlider) {
        currentTime = sender.value
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        currentTime = 0.8
    }
    
    func getCurrentComponent() -> Component {
        //TO DO: Validate
        let component = Component(context: CoreDataHelper.manager.context)
        component.estimatedTimeInSeconds = Double(timeTextField.text!)!
        component.name = componentNameTextField.text!
        component.index = Int16(index)
        return component
    }

    @IBAction private func addNewButtonPressed(_ sender: Any) {
        delegate?.addOrUpdateComponent(name: componentNameTextField.text!, estimatedTime: "\(currentTime)", index: index)
        delegate?.createNewRow()
    }
}
*/
