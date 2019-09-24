//
//  CreateTermViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

// TODO: Hacer esta vista en SwiftUI

protocol CreateTermViewControllerDelegate: class {
    func shouldRefresh()
}

class CreateTermViewController: BaseFormViewController {
    
    weak var delegate: CreateTermViewControllerDelegate?
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
//        isModalInPresentation = true
//        navigationController?.presentationController?.delegate = self
        setupNameSection(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, description: "Enter a name for the term", placeholder: "Term name")
        setupDecimalsSection(topAnchor: nameTextField.bottomAnchor)
        setupGradesSection(topAnchor: decimalsSegmentedControl.bottomAnchor)
        setupDuration()
        setupSaveButton(topAnchor: startDateTextField.bottomAnchor, action: #selector(createTerm))
        setupDelegates()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Term".localized
    }
    
    private func setupDuration() {
        let durationTitleLabel = IPTitleLabel()
        let durationDescriptionLabel = IPLabel()
        
        durationTitleLabel.text = "Duration".localized
        durationDescriptionLabel.text = "Enter the duration of the term".localized
        startDateTextField.placeholder = "From".localized
        endDateTextField.placeholder = "To".localized
        startDateTextField.delegate = self
        endDateTextField.delegate = self
        
        contentView.addSubview(durationTitleLabel)
        contentView.addSubview(durationDescriptionLabel)
        contentView.addSubview(startDateTextField)
        contentView.addSubview(endDateTextField)
        
        setupLabelConstraints(for: durationTitleLabel, topAnchor: minGradeTextField.bottomAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: durationDescriptionLabel, topAnchor: durationTitleLabel.bottomAnchor, topConstant: descriptionTopConstant)
        startDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .activate()
        endDateTextField.anchor
            .top(to: durationDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
//    override func setupSaveButton(topAnchor: NSLayoutYAxisAnchor, action: Selector) {
//        super.setupSaveButton(topAnchor: topAnchor, action: action)
//        saveButton.addTarget(self, action: #selector(createTerm), for: .touchUpInside)
//    }
    
    func setupDelegates() {
        nameTextField.delegate = self
        minGradeTextField.delegate = self
        maxGradeTextField.delegate = self
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty
            || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty
            || startDateTextField.isEmpty
            || endDateTextField.isEmpty {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    @objc private func createTerm() {
        if let name = nameTextField.text, let minGradeText = minGradeTextField.text,
            let maxGradeText = maxGradeTextField.text,
            let minGrade = Float(minGradeText),
            let maxGrade = Float(maxGradeText),
            let startDate = startDateTextField.date,
            let endDate = endDateTextField.date {
            
            if valuesAreValid(maxGrade: maxGrade, minGrade: minGrade) {
                let decimals = decimalsSegmentedControl.selectedSegmentIndex
                do {
                    try _ = Term.create(name: name, maxGrade: maxGrade, minGrade: minGrade, decimals: decimals, startDate: startDate, endDate: endDate)
                    dismissView()
                    delegate?.shouldRefresh()
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func valuesAreValid(maxGrade: Float, minGrade: Float) -> Bool {
        if maxGrade <= 0 || minGrade < 0 {
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
            return false
        }
        
        if let startDate = startDateTextField.date, let endDate = endDateTextField.date, startDate >= endDate {
            startDateTextField.showErrorBorder()
            endDateTextField.showErrorBorder()
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

//extension CreateTermViewController: UIAdaptivePresentationControllerDelegate {
//
//    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
//        let alert = UIAlertController(title: "Dismiss", message: "Dismiss", preferredStyle: .alert)
//        let acceptButton = UIAlertAction(title: "Dismiss", style: .destructive) { _ in
//            self.dismiss(animated: true)
//        }
//        let cancelButton = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//        alert.addAction(acceptButton)
//        alert.addAction(cancelButton)
//
//        present(alert, animated: true)
//    }
//
//}
