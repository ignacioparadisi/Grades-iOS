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
        textField.dateFormat = "EEE d, yyyy"
        return textField
    }()
    let endDateTextField: IPDatePickerTextField = {
        let textField = IPDatePickerTextField()
        textField.isRequired = true
        textField.datePickerMode = .date
        textField.dateFormat = "EEE d, yyyy"
        return textField
    }()

    override func setupView() {
        super.setupView()
        setupDuration()
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
            .top(to: view.topAnchor, constant: titleTopConstant)
            .trailing(to: view.trailingAnchor, constant: trailingConstant)
            .leading(to: view.leadingAnchor, constant: leadingConstant)
            .activate()
        durationDescriptionLabel.anchor
            .top(to: durationTitleLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: view.trailingAnchor, constant: trailingConstant)
            .leading(to: view.leadingAnchor, constant: leadingConstant)
            .activate()
        startDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: view.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: view.leadingAnchor, constant: leadingConstant)
            .activate()
        endDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: view.trailingAnchor, constant: trailingConstant)
            .leading(to: view.centerXAnchor, constant: leadingConstant / 2)
            .activate()
        
    }
}
