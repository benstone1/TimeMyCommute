//
//  InputComponentView.swift
//  TimeMyCommute
//
//  Created by C4Q  on 2/21/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit

protocol InputComponentViewDelegate {
    func timeDidUpdate(to: Double)
    func nameDidUpdate(to: String)
    func addNewComponentButtonPressed()
}

class InputComponentView: UIView, UITextFieldDelegate {

    public var delegate: InputComponentViewDelegate?
    
    public func configureView(with component: Component, isLastRow: Bool) {
        self.component = component
        if !isLastRow {
            hideButton()
        }
    }
    
    private var component: Component!
    
    private var estimatedTime: Double = 0 {
        didSet {
            timeSlider.value = Float(estimatedTime)
            timeTextField.text = "\(Int(estimatedTime)) minutes"
            component.estimatedTimeInMinutes = estimatedTime
        }
    }
    
    private var name: String = "" {
        didSet {
            componentNameTextField.text = name
            component.name = name
        }
    }
    
    lazy private var componentNameDisplayLabel: UILabel = {
        var lab = UILabel()
        lab.text = "Component Name"
        return lab
    }()
    
    lazy private var componentNameTextField: UITextField = {
       var tf = UITextField()
        tf.placeholder = "name"
        tf.delegate = self
        return tf
    }() 
    
    lazy private var estimatedTimeDisplayLabel: UILabel = {
       var lab = UILabel()
        lab.text = "Estimated Time"
        return lab
    }()
    
    lazy private var timeSlider: UISlider = {
        var slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 60
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        return slider
    }()
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        estimatedTime = Double(sender.value)
    }
    
    lazy private var timeTextField: UITextField = {
        var timeTF = UITextField()
        timeTF.placeholder = "0 minutes"
        return timeTF
    }()
    
    internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            self.name = updatedText
        }
        return false
    }
    
    lazy private var addNewComponentButton: UIButton = {
        var but = UIButton()
        but.setTitle("Add New Component", for: .normal)
        but.addTarget(self, action: #selector(addNewComponentButtonPressed), for: .touchUpInside)
        but.setTitleColor(.blue, for: .normal)
        return but
    }()
    
    @objc private func addNewComponentButtonPressed() {
        delegate?.addNewComponentButtonPressed()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func hideButton() {
        addNewComponentButton.isHidden = true
        addNewComponentButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
    }
    
    private func commonInit() {
        addSubview(componentNameDisplayLabel)
        componentNameDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        componentNameDisplayLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        componentNameDisplayLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        addSubview(componentNameTextField)
        componentNameTextField.translatesAutoresizingMaskIntoConstraints = false
        componentNameTextField.topAnchor.constraint(equalTo: componentNameDisplayLabel.bottomAnchor, constant: 10).isActive = true
        componentNameTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        componentNameTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        componentNameTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        
        addSubview(estimatedTimeDisplayLabel)
        estimatedTimeDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        estimatedTimeDisplayLabel.topAnchor.constraint(equalTo: componentNameTextField.bottomAnchor, constant: 10).isActive = true
        estimatedTimeDisplayLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        addSubview(timeSlider)
        timeSlider.translatesAutoresizingMaskIntoConstraints = false
        timeSlider.topAnchor.constraint(equalTo: estimatedTimeDisplayLabel.bottomAnchor, constant: 10).isActive = true
        timeSlider.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        timeSlider.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        timeSlider.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        
        addSubview(timeTextField)
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 10).isActive = true
        timeTextField.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        timeTextField.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        
        addSubview(addNewComponentButton)
        addNewComponentButton.translatesAutoresizingMaskIntoConstraints = false
        addNewComponentButton.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 10).isActive = true
        addNewComponentButton.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
        addNewComponentButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
}
