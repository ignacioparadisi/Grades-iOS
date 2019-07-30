//
//  CreateAssignmentViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol CreateAssignmentViewControllerDelegate: class {
    func didCreateAssignment()
}

class CreateAssignmentViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    weak var delegate: CreateAssignmentViewControllerDelegate?
    var assignment: Assignment?
    var contentView: UIView = UIView()
    let nameTextField: IPTextField = {
        let textField = IPTextField()
        textField.isRequired = true
        return textField
    }()
    let addButton = IPButton()
    let minQualificationTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    let maxQualificationTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    let qualificationTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()
    let percentageTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    var subject: Subject = Subject()
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupNameSection()
        setupQualificationsSection()
        setupSaveButton()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Assignment".localized
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
        nameDescriptionLabel.text = "Enter a name for the assignment".localized
        nameTextField.placeholder = "Assignment name".localized
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
        
        contentView.addSubview(qualificationTextField)
        contentView.addSubview(percentageTextField)
        qualificationTextField.placeholder = "Qualification".localized
        percentageTextField.placeholder = "Percentage".localized
        qualificationTextField.anchor
            .top(to: minQualificationTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        percentageTextField.anchor
            .top(to: maxQualificationTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createAssignment), for: .touchUpInside)
        addButton.color = ThemeManager.currentTheme.accentColor
        addButton.isEnabled = false
        contentView.addSubview(addButton)
        addButton.anchor
            .bottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            .activate()
        let topConstraint = addButton.topAnchor.constraint(greaterThanOrEqualTo: minQualificationTextField.bottomAnchor, constant: 20)
        topConstraint.isActive = true
    }
    
    func edit(_ assignment: Assignment) {
        self.assignment = assignment
        nameTextField.text = assignment.name
        minQualificationTextField.text = "\(assignment.minQualification)"
        maxQualificationTextField.text = "\(assignment.maxQualification)"
        qualificationTextField.text = "\(assignment.qualification)"
        percentageTextField.text = "\(assignment.percentage * 100)"
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty || minQualificationTextField.isEmpty
            || maxQualificationTextField.isEmpty {
            addButton.isEnabled = false
            return
        }
        addButton.isEnabled = true
    }
    
    @objc private func createAssignment() {
        if let name = nameTextField.text, let minQualificationText = minQualificationTextField.text,
            let maxQualificationText = maxQualificationTextField.text,
            let percentageText = percentageTextField.text,
            let minQualification = Float(minQualificationText),
            let maxQualification = Float(maxQualificationText),
            let percentage = Float(percentageText),
            !name.isEmpty {
            
            var qualification: Float = 0
            if let qualificationText = qualificationTextField.text, let unwrappedQualification = Float(qualificationText) {
                qualification = unwrappedQualification
            }
            
            if valuesAreValid(maxQualification: maxQualification, minQualification: minQualification, qualification: qualification, percentage: percentage) {
                let assignment = Assignment()
                assignment.subject = subject
                assignment.name = name
                assignment.minQualification = minQualification
                assignment.maxQualification = maxQualification
                assignment.percentage = percentage * 0.01
                assignment.qualification = qualification
                
                if self.assignment != nil {
                    self.assignment = assignment
                } else {
                    Factory.getServiceFactory(for: .realm).assignmentService.createAssignment(assignment)
                    // ServiceFactory.createService(.realm).createAssignment(assignment)
                }
                
                dismissView()
                delegate?.didCreateAssignment()
            }
        }
    }
    
    private func valuesAreValid(maxQualification: Float, minQualification: Float, qualification: Float, percentage: Float) -> Bool {
        if maxQualification <= 0 || minQualification < 0 || qualification < 0 {
            showErrorMessage("Qualifications must be greater than 0.".localized)
            if maxQualification <= 0 {
                maxQualificationTextField.showErrorBorder()
            }
            if minQualification <= 0 {
                minQualificationTextField.showErrorBorder()
            }
            if qualification <= 0 {
                qualificationTextField.showErrorBorder()
            }
            return false
        }
        
        if percentage <= 0 {
            percentageTextField.showErrorBorder()
            showErrorMessage("Percentage must be greater than 0.".localized)
            return false
        }
        
        if percentage > 100 {
            percentageTextField.showErrorBorder()
            showErrorMessage("Percentage must be equal or less than 100.".localized)
            return false
        }
        
        if maxQualification <= minQualification {
            maxQualificationTextField.showErrorBorder()
            minQualificationTextField.showErrorBorder()
            showErrorMessage("Maximum qualification must be greater than minimum qualification.".localized)
            return false
        }
        
        if qualification < minQualification || qualification > maxQualification {
            qualificationTextField.showErrorBorder()
            showErrorMessage("Qualification mush be between minimum qualification and maximum qualification".localized)
            return false
        }
        
        return true
    }
    
}

extension CreateAssignmentViewController: UITextFieldDelegate {
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

