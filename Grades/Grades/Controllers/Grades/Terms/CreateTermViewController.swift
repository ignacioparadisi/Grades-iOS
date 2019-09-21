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

class CreateTermViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
    
    weak var delegate: CreateTermViewControllerDelegate?
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
        isModalInPresentation = true
        navigationController?.presentationController?.delegate = self
        addScrollView()
        setupNameSection()
        setupGradesSection()
        setupDuration()
        setupSaveButton()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Term".localized
        navigationController?.navigationBar.prefersLargeTitles = false
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    private func setupLabelConstraints(for label: UILabel, topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        label.anchor
            .top(to: topAnchor, constant: topConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
            .width(constant: view.frame.width - 2 * leadingConstant)
            .activate()
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
        
        setupLabelConstraints(for: nameTitleLabel, topAnchor: contentView.safeAreaLayoutGuide.topAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: nameDescriptionLabel, topAnchor: nameTitleLabel.bottomAnchor, topConstant: descriptionTopConstant)
        nameTextField.anchor
            .top(to: nameDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant, toSafeArea: true)
            .leadingToSuperview(constant: leadingConstant, toSafeArea: true)
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
        
        setupLabelConstraints(for: gradesLabel, topAnchor: nameTextField.bottomAnchor, topConstant: titleTopConstant)
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
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createTerm), for: .touchUpInside)
        addButton.color = UIColor(named: "accentColor")
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
        if nameTextField.isEmpty
            || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty
            || startDateTextField.isEmpty
            || endDateTextField.isEmpty {
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
                Term.create(name: name, maxGrade: maxGrade, minGrade: minGrade, startDate: startDate, endDate: endDate)
                dismissView()
                delegate?.shouldRefresh()
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

extension CreateTermViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Dismiss", message: "Dismiss", preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Dismiss", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let cancelButton = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(acceptButton)
        alert.addAction(cancelButton)

        present(alert, animated: true)
    }
    
}
