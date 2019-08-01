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
    let gradeTextField: IPTextField = {
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
    let datePickerTextField: IPDatePickerTextField = {
        let picker = IPDatePickerTextField()
        picker.isRequired = true
        picker.datePickerMode = .dateAndTime
        picker.dateFormat = "MMM d, yyyy h:mma"
        picker.placeholder = "On date".localized
        return picker
    }()
    var subject: Subject = Subject()
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupNameSection()
        setupGradesSection()
        setupDateSection()
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
        
        contentView.addSubview(gradeTextField)
        contentView.addSubview(percentageTextField)
        gradeTextField.placeholder = "Grade".localized
        percentageTextField.placeholder = "Percentage".localized
        gradeTextField.anchor
            .top(to: minGradeTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        percentageTextField.anchor
            .top(to: maxGradeTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupDateSection() {
        let dateLabel = IPTitleLabel()
        let dateDescriptionLabel = IPLabel()
        
        dateLabel.text = "Date and time".localized
        dateDescriptionLabel.text = "Enter the date and time of the assignment".localized
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateDescriptionLabel)
        contentView.addSubview(datePickerTextField)
        
        dateLabel.anchor
            .top(to: gradeTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        dateDescriptionLabel.anchor
            .top(to: dateLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        datePickerTextField.anchor
            .top(to: dateDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
    }
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createAssignment), for: .touchUpInside)
        addButton.color = ThemeManager.currentTheme.accentColor
        addButton.isEnabled = false
        contentView.addSubview(addButton)
        addButton.anchor
            .top(greaterOrEqual: datePickerTextField.bottomAnchor, constant: titleTopConstant)
            .bottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            .activate()
        let topConstraint = addButton.topAnchor.constraint(greaterThanOrEqualTo: minGradeTextField.bottomAnchor, constant: 20)
        topConstraint.isActive = true
    }
    
    func edit(_ assignment: Assignment) {
        self.assignment = assignment
        nameTextField.text = assignment.name
        minGradeTextField.text = "\(assignment.minGrade)"
        maxGradeTextField.text = "\(assignment.maxGrade)"
        gradeTextField.text = "\(assignment.grade)"
        percentageTextField.text = "\(assignment.percentage * 100)"
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty {
            addButton.isEnabled = false
            return
        }
        addButton.isEnabled = true
    }
    
    @objc private func createAssignment() {
        if let name = nameTextField.text, let minGradeText = minGradeTextField.text,
            let maxGradeText = maxGradeTextField.text,
            let percentageText = percentageTextField.text,
            let minGrade = Float(minGradeText),
            let maxGrade = Float(maxGradeText),
            let percentage = Float(percentageText),
            !name.isEmpty {
            
            var grade: Float = 0
            if let gradeText = gradeTextField.text, let unwrappedGrade = Float(gradeText) {
                grade = unwrappedGrade
            }
            
            if valuesAreValid(maxGrade: maxGrade, minGrade: minGrade, grade: grade, percentage: percentage) {
                let assignment = Assignment()
                assignment.subject = subject
                assignment.name = name
                assignment.minGrade = minGrade
                assignment.maxGrade = maxGrade
                assignment.percentage = percentage * 0.01
                assignment.grade = grade
                
                if self.assignment != nil {
                    self.assignment = assignment
                } else {
                    AbstractServiceFactory.getServiceFactory(for: .realm).assignmentService.createAssignment(assignment)
                }
                
                dismissView()
                delegate?.didCreateAssignment()
            }
        }
    }
    
    private func valuesAreValid(maxGrade: Float, minGrade: Float, grade: Float, percentage: Float) -> Bool {
        if maxGrade <= 0 || minGrade < 0 || grade < 0 {
            showErrorMessage("Grades must be greater than 0.".localized)
            if maxGrade <= 0 {
                maxGradeTextField.showErrorBorder()
            }
            if minGrade <= 0 {
                minGradeTextField.showErrorBorder()
            }
            if grade <= 0 {
                gradeTextField.showErrorBorder()
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
        
        if maxGrade <= minGrade {
            maxGradeTextField.showErrorBorder()
            minGradeTextField.showErrorBorder()
            showErrorMessage("Maximum grade must be greater than minimum grade.".localized)
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

