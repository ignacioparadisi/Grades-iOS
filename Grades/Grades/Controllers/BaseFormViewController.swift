//
//  BaseFormViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/23/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BaseFormViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    var contentView: UIView = UIView()
    lazy var nameTextField: IPTextField = {
        let textField = IPTextField()
        textField.isRequired = true
        return textField
    }()
    lazy var decimalsSegmentedControl: UISegmentedControl = {
        let items = ["1", "0.1", "0.01"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    lazy var minGradeTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    lazy var maxGradeTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    let saveButton: IPButton = {
        let button = IPButton()
        button.setTitle("Save".localized, for: .normal)
        return button
    }()
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationController?.navigationBar.prefersLargeTitles = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func setupView() {
        super.setupView()
        addScrollView()
    }
    
    @objc internal func dismissView() {
        dismiss(animated: true)
    }
    
    internal func setupNameSection(topAnchor: NSLayoutYAxisAnchor, description: String, placeholder: String) {
        let nameTitleLabel = IPTitleLabel()
        let nameDescriptionLabel = IPLabel()
        
        nameTitleLabel.text = "Name".localized
        nameDescriptionLabel.text = description.localized
        nameTextField.placeholder = placeholder.localized
        
        contentView.addSubview(nameTitleLabel)
        contentView.addSubview(nameDescriptionLabel)
        contentView.addSubview(nameTextField)
        
        setupLabelConstraints(for: nameTitleLabel, topAnchor: topAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: nameDescriptionLabel, topAnchor: nameTitleLabel.bottomAnchor, topConstant: descriptionTopConstant)
        nameTextField.anchor
            .top(to: nameDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .activate()
    }
    
    internal func setupDecimalsSection(topAnchor: NSLayoutYAxisAnchor, selectedIndex: Int = 0) {
        let label = IPTitleLabel()
        let descriptionLabel = IPLabel()
        
        label.text = "Decimals".localized
        descriptionLabel.text = "Select the amount of decimals to show".localized
        decimalsSegmentedControl.selectedSegmentIndex = selectedIndex
        
        contentView.addSubview(label)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(decimalsSegmentedControl)
        
        setupLabelConstraints(for: label, topAnchor: topAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: descriptionLabel, topAnchor: label.bottomAnchor, topConstant: descriptionTopConstant)
        decimalsSegmentedControl.anchor
            .top(to: descriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
    }
    
    internal func setupGradesSection(topAnchor: NSLayoutYAxisAnchor) {
        let gradesLabel = IPTitleLabel()
        let gradesDescriptionLabel = IPLabel()
        
        gradesLabel.text = "Grades".localized
        gradesDescriptionLabel.text = "Enter max and min grade to pass".localized
        maxGradeTextField.placeholder = "Max. Grade".localized
        minGradeTextField.placeholder = "Min. Grade".localized
        
        contentView.addSubview(gradesLabel)
        contentView.addSubview(gradesDescriptionLabel)
        contentView.addSubview(minGradeTextField)
        contentView.addSubview(maxGradeTextField)
        
        setupLabelConstraints(for: gradesLabel, topAnchor: topAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: gradesDescriptionLabel, topAnchor: gradesLabel.bottomAnchor, topConstant: descriptionTopConstant)
        minGradeTextField.anchor
            .top(to: gradesDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .activate()
        maxGradeTextField.anchor
            .top(to: gradesDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    internal func setupSaveButton(topAnchor: NSLayoutYAxisAnchor, action: Selector) {
        saveButton.setTitle("Save".localized, for: .normal)
        saveButton.addTarget(self, action: action, for: .touchUpInside)
        saveButton.isEnabled = false
        contentView.addSubview(saveButton)
        saveButton.anchor
            .top(greaterOrEqual: topAnchor, constant: titleTopConstant)
            .bottomToSuperview(constant: -titleTopConstant, toSafeArea: true)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .activate()
    }
    
    internal func setupLabelConstraints(for label: UILabel, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        label.anchor
            .top(to: topAnchor, constant: topConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .width(constant: view.frame.width - 2 * leadingConstant)
            .activate()
    }
}
