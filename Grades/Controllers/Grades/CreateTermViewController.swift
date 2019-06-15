//
//  CreateTermViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol CreateTermViewControllerDelegate: class {
    func didCreateTerm()
}

class CreateTermViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    weak var delegate: CreateTermViewControllerDelegate?
    var contentView: UIView = UIView()
    let nameTextField = IPTextField()
    let addButton = IPButton()
    let minQualificationTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()
    let maxQualificationTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()
    let startDateButton: IPButton = {
        let button = IPButton()
        button.titleLabel?.font = ThemeManager.currentTheme.font(style: .regular, size: 17.0)
        // button.setTitleColor(ThemeManager.currentTheme.placeholderColor, for: .normal)
        button.color = ThemeManager.currentTheme.cardBackgroundColor
        button.highlightDarknessPercentage = 4
        return button
    }()
    let endDateButton: IPButton = {
        let button = IPButton()
        button.titleLabel?.font = ThemeManager.currentTheme.font(style: .regular, size: 17.0)
        // button.setTitleColor(ThemeManager.currentTheme.placeholderColor, for: .normal)
        button.color = ThemeManager.currentTheme.cardBackgroundColor
        button.highlightDarknessPercentage = 4
        return button
    }()
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupNameSection()
        setupQualificationsSection()
        setupDuration()
        setupSaveButton()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Term".localized
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    private func setupNameSection() {
        let nameTitleLabel = IPTitleLabel()
        let nameDescriptionLabel = IPLabel()
        
        nameTitleLabel.text = "Name".localized
        nameDescriptionLabel.text = "Enter a name for the term".localized
        nameTextField.placeholder = "Term name".localized
        nameTextField.delegate = self
        
        contentView.addSubview(nameTitleLabel)
        contentView.addSubview(nameDescriptionLabel)
        contentView.addSubview(nameTextField)
        
        nameTitleLabel.anchor
            .top(to: contentView.safeAreaLayoutGuide.topAnchor, constant: titleTopConstant)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant)
            .activate()
        nameDescriptionLabel.anchor
            .top(to: nameTitleLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant)
            .activate()
        nameTextField.anchor
            .top(to: nameDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: leadingConstant)
            .activate()
    }
    
    private func setupQualificationsSection() {
        let qualificationsLabel = IPTitleLabel()
        let qualificationDescriptionLabel = IPLabel()
        
        qualificationsLabel.text = "Qualifications".localized
        qualificationDescriptionLabel.text = "Enter max and min qualification to pass".localized
        maxQualificationTextField.placeholder = "Max. Qualification".localized
        minQualificationTextField.placeholder = "Min. Qualification".localized
        maxQualificationTextField.delegate = self
        minQualificationTextField.delegate = self
        
        contentView.addSubview(qualificationsLabel)
        contentView.addSubview(qualificationDescriptionLabel)
        contentView.addSubview(minQualificationTextField)
        contentView.addSubview(maxQualificationTextField)
        
        qualificationsLabel.anchor
            .top(to: nameTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        qualificationDescriptionLabel.anchor
            .top(to: qualificationsLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        minQualificationTextField.anchor
            .top(to: qualificationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        maxQualificationTextField.anchor
            .top(to: qualificationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupDuration() {
        let durationTitleLabel = IPTitleLabel()
        let durationDescriptionLabel = IPLabel()
        
        durationTitleLabel.text = "Duration"
        durationDescriptionLabel.text = "Enter the duration of the term"
        startDateButton.setTitle("From", for: .normal)
        endDateButton.setTitle("To", for: .normal)
        
        contentView.addSubview(durationTitleLabel)
        contentView.addSubview(durationDescriptionLabel)
        contentView.addSubview(startDateButton)
        contentView.addSubview(endDateButton)
        
        durationTitleLabel.anchor
            .top(to: minQualificationTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        durationDescriptionLabel.anchor
            .top(to: durationTitleLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        startDateButton.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        endDateButton.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
        
    }
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createTerm), for: .touchUpInside)
        addButton.color = ThemeManager.currentTheme.accentColor
        addButton.isEnabled = false
        contentView.addSubview(addButton)
        addButton.anchor
            .bottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            .activate()
        let topConstraint = addButton.topAnchor.constraint(greaterThanOrEqualTo: startDateButton.bottomAnchor, constant: 20)
        topConstraint.isActive = true
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty || minQualificationTextField.isEmpty
            || maxQualificationTextField.isEmpty {
            addButton.isEnabled = false
            return
        }
        addButton.isEnabled = true
    }
    
    @objc private func createTerm() {
        if let name = nameTextField.text, let minQualificationText = minQualificationTextField.text,
            let maxQualificationText = maxQualificationTextField.text,
            let minQualification = Float(minQualificationText),
            let maxQualification = Float(maxQualificationText) {
            
            let term = Term()
            term.name = name
            term.minQualification = minQualification
            term.maxQualification = maxQualification
            
            ServiceFactory.createService(.realm).createTerm(term)
            dismissView()
            delegate?.didCreateTerm()
        }
        
        
    }

}

extension CreateTermViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            _ = nameTextField.resignFirstResponder()
            _ = minQualificationTextField.becomeFirstResponder()
        case minQualificationTextField:
            _ = minQualificationTextField.resignFirstResponder()
            _ = maxQualificationTextField.becomeFirstResponder()
        default:
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkRequiredFields()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkRequiredFields()
    }
}
