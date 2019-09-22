//
//  EditTermViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol EditTermViewControllerDelegate: class {
    func didEditTerm(_ term: Term)
    func didDeleteTerm()
}

class EditTermViewController: BaseViewController {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    weak var delegate: EditTermViewControllerDelegate?
    var term: Term = Term()
    let startDateTextField: IPDatePickerTextField = {
        let textField = IPDatePickerTextField()
        textField.isRequired = true
        textField.datePickerMode = .date
        textField.dateFormat = "MMM d, yyyy"
        return textField
    }()
    let endDateTextField: IPDatePickerTextField = {
        let textField = IPDatePickerTextField()
        textField.isRequired = true
        textField.datePickerMode = .date
        textField.dateFormat = "MMM d, yyyy"
        return textField
    }()
    let saveButton: IPButton = {
        let button = IPButton()
        button.backgroundColor = UIColor(named: "accentColor")
        button.setTitle("Save".localized, for: .normal)
        button.addTarget(self, action: #selector(didEditTerm), for: .touchUpInside)
        return button
    }()

    override func setupView() {
        super.setupView()
        setupDuration()
        setupDeleteButton()
        setupSaveButton()
        
        startDateTextField.date = term.startDate
        endDateTextField.date = term.endDate
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = term.name
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupDuration() {
        let durationTitleLabel = IPTitleLabel()
        let durationDescriptionLabel = IPLabel()
        
        durationTitleLabel.text = "Duration".localized
        durationDescriptionLabel.text = "Enter the duration of the term".localized
        startDateTextField.placeholder = "From".localized
        endDateTextField.placeholder = "To".localized
        
        view.addSubview(durationTitleLabel)
        view.addSubview(durationDescriptionLabel)
        view.addSubview(startDateTextField)
        view.addSubview(endDateTextField)
        
        durationTitleLabel.anchor
            .topToSuperview(constant: titleTopConstant, toSafeArea: true)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
        durationDescriptionLabel.anchor
            .top(to: durationTitleLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
        startDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: view.centerXAnchor, constant: trailingConstant / 2)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
        endDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leading(to: view.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupDeleteButton() {
        let deleteButton = IPButton()
        deleteButton.backgroundColor = .systemGray4
        deleteButton.setTitle("Delete".localized, for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteTerm), for: .touchUpInside)
        
        view.addSubview(deleteButton)
        
        deleteButton.anchor
            .top(to: startDateTextField.bottomAnchor, constant: titleTopConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .activate()
    }
    
    @objc private func deleteTerm() {
        term.delete()
        delegate?.didDeleteTerm()
        dismiss(animated: true)
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.anchor
            .trailingToSuperview(constant: trailingConstant)
            .bottomToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
    }
    
    private func valuesAreValid() -> Bool {
        if let startDate = startDateTextField.date, let endDate = endDateTextField.date, startDate >= endDate {
            startDateTextField.showErrorBorder()
            endDateTextField.showErrorBorder()
            return false
        }
        
        return true
    }
    
    @objc private func didEditTerm() {
        if valuesAreValid(), let startDate = startDateTextField.date,
            let endDate = endDateTextField.date {
            term.update(name: term.name, startDate: startDate, endDate: endDate)
            delegate?.didEditTerm(term)
            dismissView()
        }
    }
    
}
