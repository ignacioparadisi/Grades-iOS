//
//  AssignmentDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/22/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol AssignmentDetailViewControllerDelegate: class {
    func didEditAssignment()
}

class AssignmentDetailViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    var contentView: UIView = UIView()
    weak var delegate: AssignmentDetailViewControllerDelegate?
    var assignment: Assignment = Assignment()
    var circularSlider: CircularSlider!
    var decimalsSegmentedControl: UISegmentedControl = {
        let items = ["1", "0.1", "0.01"]
        let segmentedControl = UISegmentedControl(items: items)
        return segmentedControl
    }()
    var deadlineTextField: IPDatePickerTextField = {
        let picker = IPDatePickerTextField()
        picker.isRequired = true
        picker.datePickerMode = .dateAndTime
        picker.dateFormat = .dateAndTime
        picker.placeholder = "Deadline".localized
        return picker
    }()
    var editButton: UIBarButtonItem!
    var saveButton: UIBarButtonItem!
    var isEditEnabled: Bool = false

    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = assignment.name
        navigationController?.navigationBar.prefersLargeTitles = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(enableEdit))
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(updateAssignment))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = editButton
        disableEdit()
    }
    
    @objc private func dismissView() {
        if isEditEnabled {
            disableEdit()
        } else {
            dismiss(animated: true)
        }
    }
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupDecimalsSection()
        setupCircularSlider()
        setupDeadline()
    }
    
    @objc private func enableEdit() {
        isEditEnabled = true
        navigationItem.setRightBarButton(saveButton, animated: true)
        decimalsSegmentedControl.isUserInteractionEnabled = true
        circularSlider.isUserInteractionEnabled = true
        deadlineTextField.isUserInteractionEnabled = true
        saveButton.isEnabled = true
    }
    
    private func disableEdit() {
        isEditEnabled = false
        navigationItem.setRightBarButton(editButton, animated: true)
        decimalsSegmentedControl.isUserInteractionEnabled = false
        circularSlider.isUserInteractionEnabled = false
        deadlineTextField.isUserInteractionEnabled = false
        saveButton.isEnabled = false
    }
    
    private func setupDecimalsSection() {
        let label = IPTitleLabel()
        let descriptionLabel = IPLabel()
        
        label.text = "Decimals".localized
        descriptionLabel.text = "Select the amount of decimals to show".localized
        decimalsSegmentedControl.selectedSegmentIndex = Int(assignment.decimals)
        decimalsSegmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        contentView.addSubview(label)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(decimalsSegmentedControl)
        
        setupLabelConstraints(for: label, topAnchor: contentView.topAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: descriptionLabel, topAnchor: label.bottomAnchor, topConstant: descriptionTopConstant)
        decimalsSegmentedControl.anchor
            .top(to: descriptionLabel.bottomAnchor, constant: titleTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
    }
    
    private func setupCircularSlider() {
        circularSlider = CircularSlider(frame: .zero)
        circularSlider.title = "Grade".localized
        circularSlider.gradable = assignment
        circularSlider.radiansOffset = 1
        circularSlider.lineWidth = 20
        circularSlider.knobRadius = 30
        circularSlider.numberOfDecimals = decimalsSegmentedControl.selectedSegmentIndex
        
        contentView.addSubview(circularSlider)
        circularSlider.anchor
            .top(to: decimalsSegmentedControl.bottomAnchor, constant: 60)
            .trailingToSuperview(constant: -50)
            .leadingToSuperview(constant: 50)
            .height(to: circularSlider.widthAnchor)
            .activate()
    }
    
    private func setupDeadline() {
        let dateLabel = IPTitleLabel()
        let dateDescriptionLabel = IPLabel()
        deadlineTextField.date = assignment.deadline
        
        dateLabel.text = "Date and time".localized
        dateDescriptionLabel.text = "Enter the date and time of the assignment".localized
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateDescriptionLabel)
        contentView.addSubview(deadlineTextField)
        
        setupLabelConstraints(for: dateLabel, topAnchor: circularSlider.bottomAnchor)
        setupLabelConstraints(for: dateDescriptionLabel, topAnchor: dateLabel.bottomAnchor, topConstant: descriptionTopConstant)
        deadlineTextField.anchor
            .top(to: dateDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .leadingToSuperview(constant: leadingConstant)
            .trailingToSuperview(constant: trailingConstant)
            .bottomToSuperview(constant: -20, toSafeArea: true)
            .activate()
    }
    
    private func setupLabelConstraints(for label: UILabel, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat = 0) {
        label.anchor
            .top(to: topAnchor, constant: topConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .width(constant: view.frame.width - 2 * leadingConstant)
            .activate()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        circularSlider.numberOfDecimals = sender.selectedSegmentIndex
    }
    
    @objc private func updateAssignment() {
        assignment.update(grade: circularSlider.value, decimals: decimalsSegmentedControl.selectedSegmentIndex)
        delegate?.didEditAssignment()
        dismiss(animated: true)
    }

}
