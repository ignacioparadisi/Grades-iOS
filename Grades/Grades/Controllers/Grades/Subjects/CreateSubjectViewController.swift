//
//  CreateSubjectViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol CreateSubjectViewControllerDelegate: class {
    func shouldRefresh()
}

class CreateSubjectViewController: BaseFormViewController {
    
    weak var delegate: CreateSubjectViewControllerDelegate?
    var term: Term = Term()
    
    override func setupView() {
        super.setupView()
        setupNameSection(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, description: "Enter a name for the subject", placeholder: "Subject name")
        setupDecimalsSection(topAnchor: nameTextField.bottomAnchor)
        setupGradesSection(topAnchor: decimalsSegmentedControl.bottomAnchor)
        setupDelegates()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Subject".localized
    }
    
    override func setupGradesSection(topAnchor: NSLayoutYAxisAnchor) {
        super.setupGradesSection(topAnchor: topAnchor)
        minGradeTextField.anchor.bottomToSuperview(constant: -titleTopConstant, toSafeArea: true).activate()
        maxGradeTextField.anchor.bottom(to: minGradeTextField.bottomAnchor).activate()
    }
    
    private func setupDelegates() {
        nameTextField.delegate = self
        maxGradeTextField.delegate = self
        minGradeTextField.delegate = self
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    @objc private func createSubject() {
        if let name = nameTextField.text, let minGradeText = minGradeTextField.text,
            let maxGradeText = maxGradeTextField.text,
            let minGrade = Float(minGradeText),
            let maxGrade = Float(maxGradeText) {
            
            if valuesAreValid(maxGrade: maxGrade, minGrade: minGrade) {
                let decimals = decimalsSegmentedControl.selectedSegmentIndex
                Subject.create(name: name, maxGrade: maxGrade, minGrade: minGrade, decimals: decimals, term: term)
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
        return true
    }
}

extension CreateSubjectViewController: UITextFieldDelegate {
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

extension CreateSubjectViewController: UIAdaptivePresentationControllerDelegate {
    
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
