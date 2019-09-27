//
//  CreateAssignmentViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import UserNotifications

protocol CreateAssignmentViewControllerDelegate: class {
    func didCreateAssignment()
}

class CreateAssignmentViewController: BaseFormViewController {
    
    weak var delegate: CreateAssignmentViewControllerDelegate?
    var subject: Subject = Subject()
    let gradeTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()
    let percentageTextField: IPTextField = {
        let textField = IPTextField()
        textField.keyboardType = .decimalPad
        return textField
    }()
    let switchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    let testView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    var testHeightAnchor: NSLayoutConstraint?
    let deadlinePickerTextField: IPDatePickerTextField = {
        let picker = IPDatePickerTextField()
        picker.isRequired = true
        picker.datePickerMode = .dateAndTime
        picker.dateFormat = .dateAndTime
        picker.placeholder = "On date".localized
        return picker
    }()
    
    override func setupView() {
        super.setupView()
        setupNameSection(topAnchor: contentView.safeAreaLayoutGuide.topAnchor, description: "Enter a name for the assignment", placeholder: "Enter a name for the assignment")
        setupDecimalsSection(topAnchor: nameTextField.bottomAnchor)
        setupGradesSection(topAnchor: decimalsSegmentedControl.bottomAnchor)
        setupChildSwitchSection()
        setupDateSection()
        setupSaveButton(topAnchor: deadlinePickerTextField.bottomAnchor, action: #selector(createAssignment))
        setupDelegates()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Add Assignment".localized
    }
    
    private func setupDelegates() {
        nameTextField.delegate = self
        maxGradeTextField.delegate = self
        minGradeTextField.delegate = self
        gradeTextField.delegate = self
        percentageTextField.delegate = self
        deadlinePickerTextField.delegate = self
    }
    
    override func setupGradesSection(topAnchor: NSLayoutYAxisAnchor) {
        super.setupGradesSection(topAnchor: topAnchor)
        contentView.addSubview(gradeTextField)
        contentView.addSubview(percentageTextField)
        gradeTextField.placeholder = "Grade".localized
        percentageTextField.placeholder = "Percentage".localized
        percentageTextField.delegate = self
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
    
    private func setupChildSwitchSection() {
        let titleLabel = IPTitleLabel()
        let switchLabel = IPLabel()
        let childsSwitch = UISwitch()
        childsSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        titleLabel.text = "Composition".localized
        switchLabel.text = "The assignments is composed by other assignments".localized
        switchLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        setupLabelConstraints(for: titleLabel, topAnchor: percentageTextField.bottomAnchor, topConstant: titleTopConstant)
        
        contentView.addSubview(switchContainerView)
        switchContainerView.anchor
            .top(to: titleLabel.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .width(constant: view.frame.width - 2 * leadingConstant)
            .activate()
        
        switchContainerView.addSubview(switchLabel)
        switchContainerView.addSubview(childsSwitch)
        
        switchLabel.anchor
            .topToSuperview(constant: leadingConstant)
            .trailing(to: childsSwitch.leadingAnchor, constant: trailingConstant)
            .bottomToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .activate()
        childsSwitch.anchor
            .centerYToSuperview()
            .trailingToSuperview(constant: trailingConstant)
            .width(constant: 47)
            .activate()
        
        contentView.addSubview(testView)
        testView.anchor
            .top(to: switchContainerView.bottomAnchor, constant: fieldTopConstant)
            .trailingToSuperview(constant: trailingConstant)
            .leadingToSuperview(constant: leadingConstant)
            .width(constant: view.frame.width - 2 * leadingConstant)
            .activate()
        
        testHeightAnchor = testView.heightAnchor.constraint(equalToConstant: 0)
        testHeightAnchor?.isActive = true
    }
    
    private func setupDateSection() {
        let dateLabel = IPTitleLabel()
        let dateDescriptionLabel = IPLabel()
        
        dateLabel.text = "Date and time".localized
        dateDescriptionLabel.text = "Enter the date and time of the assignment".localized
        deadlinePickerTextField.delegate = self
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateDescriptionLabel)
        contentView.addSubview(deadlinePickerTextField)
        
        setupLabelConstraints(for: dateLabel, topAnchor: testView.bottomAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: dateDescriptionLabel, topAnchor: dateLabel.bottomAnchor, topConstant: descriptionTopConstant)
        deadlinePickerTextField.anchor
            .top(to: dateDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
    }
    
    @objc private func switchValueChanged(_ childsSwitch: UISwitch) {
        testHeightAnchor?.constant = childsSwitch.isOn ? 100 : 0
        UIView.animate(withDuration: 0.3) {
            self.testView.alpha = childsSwitch.isOn ? 1 : 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func checkRequiredFields() {
        if nameTextField.isEmpty
            || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty
            || deadlinePickerTextField.isEmpty {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    @objc private func createAssignment() {
        if let name = nameTextField.text, let minGradeText = minGradeTextField.text,
            let maxGradeText = maxGradeTextField.text,
            let minGrade = Float(minGradeText),
            let maxGrade = Float(maxGradeText),
            let deadline = deadlinePickerTextField.date,
            !name.isEmpty {
            
            var grade: Float = 0
            var percentage: Float = -1
            if let gradeText = gradeTextField.text, let gradeFloat = Float(gradeText) {
                grade = gradeFloat
            }
            if let percentageText = percentageTextField.text, let percentageFloat = Float(percentageText) {
                percentage = percentageFloat
            }
            
            if valuesAreValid(maxGrade: maxGrade, minGrade: minGrade, grade: grade, percentage: percentage) {
                let decimals = decimalsSegmentedControl.selectedSegmentIndex
                let assignment = Assignment.create(name: name, grade: grade, maxGrade: maxGrade, minGrade: minGrade, percentage: percentage, decimals: decimals, deadline: deadline, subject: subject)
                requestNotificationsAuthorization()
                createNotification(for: assignment, subjectName: subject.name)
                dismissView()
                delegate?.didCreateAssignment()
            }
        }
    }
    
    private func requestNotificationsAuthorization() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { granted, error in
            if !granted {
                print("User did not authorize notifications")
            }
            if let error = error {
                print(error)
            }
        }
    }
    
    private func createNotification(for assignment: Assignment, subjectName: String) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            
            if settings.alertSetting == .enabled {
                self.scheduleNotification(for: assignment, subjectName: subjectName, notificationCenter: center)
            }
        }
    }
    
    private func scheduleNotification(for assignment: Assignment, subjectName: String, notificationCenter center: UNUserNotificationCenter) {
        if assignment.deadline > Date() {
            let dateFormatter = DateFormatter()
            let day = dateFormatter.string(from: assignment.deadline, format: .weekday)
            let time = dateFormatter.string(from: assignment.deadline, format: .time)
            
            let content = UNMutableNotificationContent()
            content.title = "\(assignment.name) of \(subjectName)"
            content.body = "You have \(assignment.name) on \(day) at \(time)"
            content.sound = .default
            
            guard let weekBefore = Calendar.current.date(byAdding: .day, value: -7, to: assignment.deadline) else { return }
            guard let dayBefore = Calendar.current.date(byAdding: .day, value: -1, to: assignment.deadline) else { return }
            let notificationDates: [Date] = [weekBefore, dayBefore]
            
            for notificationDate in notificationDates {
                let date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                let identifier = String(describing: Date())
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print(error)
                    } else {
                        print("Scheduled Notification")
                    }
                }
            }
        }
    }
    
    private func valuesAreValid(maxGrade: Float, minGrade: Float, grade: Float, percentage: Float) -> Bool {
        var valid = true
        if maxGrade <= 0 {
            maxGradeTextField.showErrorBorder()
            valid = false
        }
        if minGrade <= 0 {
            minGradeTextField.showErrorBorder()
            valid = false
        }
        if grade < 0 || grade > maxGrade {
            gradeTextField.showErrorBorder()
            valid = false
        }
        if percentage < -1 || (percentage > -1 && percentage < 0) || percentage > 100 {
            percentageTextField.showErrorBorder()
            valid = false
        }
        if maxGrade <= minGrade {
            maxGradeTextField.showErrorBorder()
            minGradeTextField.showErrorBorder()
            valid = false
        }
        return valid
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

