//
//  CreateTermViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftMessages

protocol CreateTermViewControllerDelegate: class {
    func shouldRefresh()
}

class CreateTermViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    weak var delegate: CreateTermViewControllerDelegate?
    var term: Term?
    var termsCount: Int = 0
    var contentView: UIView = UIView()
    let nameTextField: IPTextField = {
        let textField = IPTextField()
        textField.isRequired = true
        return textField
    }()
    let addButton = IPButton()
    let minGradeTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
    let maxGradeTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        textField.isRequired = true
        return textField
    }()
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
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupNameSection()
        setupGradesSection()
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
    
    private func setupGradesSection() {
        let gradesLabel = IPTitleLabel()
        let gradesDescriptionLabel = IPLabel()
        
        gradesLabel.text = "Grades".localized
        gradesDescriptionLabel.text = "Enter max and min grade to pass".localized
        maxGradeTextField.placeholder = "Max. Grade".localized
        minGradeTextField.placeholder = "Min. Grade".localized
        maxGradeTextField.delegate = self
        minGradeTextField.delegate = self
        
        contentView.addSubview(gradesLabel)
        contentView.addSubview(gradesDescriptionLabel)
        contentView.addSubview(minGradeTextField)
        contentView.addSubview(maxGradeTextField)
        
        gradesLabel.anchor
            .top(to: nameTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        gradesDescriptionLabel.anchor
            .top(to: gradesLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        minGradeTextField.anchor
            .top(to: gradesDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        maxGradeTextField.anchor
            .top(to: gradesDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupDuration() {
        let durationTitleLabel = IPTitleLabel()
        let durationDescriptionLabel = IPLabel()
        
        durationTitleLabel.text = "Duration".localized
        durationDescriptionLabel.text = "Enter the duration of the term".localized
        startDateTextField.placeholder = "From".localized
        endDateTextField.placeholder = "To".localized
        
        contentView.addSubview(durationTitleLabel)
        contentView.addSubview(durationDescriptionLabel)
        contentView.addSubview(startDateTextField)
        contentView.addSubview(endDateTextField)
        
        durationTitleLabel.anchor
            .top(to: minGradeTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        durationDescriptionLabel.anchor
            .top(to: durationTitleLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        startDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        endDateTextField.anchor
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
            .top(greaterOrEqual: startDateTextField.bottomAnchor, constant: 20)
            .bottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            .activate()
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty {
            addButton.isEnabled = false
            return
        }
        addButton.isEnabled = true
    }
    
    @objc private func createTerm() {
        if let name = nameTextField.text, let minGradeText = minGradeTextField.text,
            let maxGradeText = maxGradeTextField.text,
            let minGrade = Float(minGradeText),
            let maxGrade = Float(maxGradeText),
            let startDate = startDateTextField.date,
            let endDate = endDateTextField.date {
            
            if valuesAreValid(maxGrade: maxGrade, minGrade: minGrade) {
                let term = Term()
                term.name = name
                term.minGrade = minGrade
                term.maxGrade = maxGrade
                term.startDate = startDate
                term.endDate = endDate
                term.position = termsCount
                
                AbstractServiceFactory.getServiceFactory(for: .realm).termService.createTerm(term)
                dismissView()
                delegate?.shouldRefresh()
            }
        }
    }
    
    private func valuesAreValid(maxGrade: Float, minGrade: Float) -> Bool {
        if maxGrade <= 0 || minGrade < 0 {
            showErrorMessage("Grades must be greater than 0.".localized)
            if maxGrade <= 0 {
                maxGradeTextField.showErrorBorder()
            }
            if minGrade <= 0 {
                minGradeTextField.showErrorBorder()
            }
            return false
        }
        
        if maxGrade <= minGrade {
            maxGradeTextField.showErrorBorder()
            minGradeTextField.showErrorBorder()
            showErrorMessage("Maximum grade must be greater than minimum grade.".localized)
            return false
        }
        
        if let startDate = startDateTextField.date, let endDate = endDateTextField.date, startDate >= endDate {
            startDateTextField.showErrorBorder()
            endDateTextField.showErrorBorder()
            showErrorMessage("End date of the term must be greater than start date.".localized)
            return false
        }
        
        return true
    }
}

extension CreateTermViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            _ = nameTextField.resignFirstResponder()
            _ = minGradeTextField.becomeFirstResponder()
        case minGradeTextField:
            _ = minGradeTextField.resignFirstResponder()
            _ = maxGradeTextField.becomeFirstResponder()
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
