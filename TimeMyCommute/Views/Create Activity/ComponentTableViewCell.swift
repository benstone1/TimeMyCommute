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
    func moveViewsToAccomadateKeyboard(with keyboardRect: CGRect, cell: ComponentTableViewCell, and duration: Double)
}

class ComponentTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .green
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleKeyboardAppearing(sender:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
    }
    
    @objc func handleKeyboardAppearing(sender: Notification) {
        guard let infoDict = sender.userInfo else { return }
        guard let rectValue = infoDict[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let duration = infoDict[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        delegate?.moveViewsToAccomadateKeyboard(with: rectValue, cell: self, and: duration)
    }
    
    public func configureCell(with component: Component, cellType: CellType, isLastRow: Bool) {
        self.component = component
        changeCellType(to: cellType, isLastRow: isLastRow)
    }
    
    public func resetFields() {
        inputComponentView.resetFields()
    }
    
    private var inputBottomConstraint: NSLayoutConstraint? = nil
    
    private func changeCellType(to cellType: CellType, isLastRow: Bool) {
        switch cellType {
        case .compressed:
                self.inputComponentView.removeFromSuperview()
                self.addCompressedViewToHierarchy()
                self.compressedComponentView.configureView(with: self.component)
            
        case .input:
                self.compressedComponentView.removeFromSuperview()
                self.addInputViewToHierarchy()
                self.inputComponentView.configureView(with: self.component, isLastRow: isLastRow)
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
        component.estimatedTimeInMinutes = Int16(newTime)
    }
    
    func nameDidUpdate(to newName: String) {
        component.name = newName
    }
    
    func addNewComponentButtonPressed() {
        delegate?.createNewRow(componentToAppend: component)
    }
}
