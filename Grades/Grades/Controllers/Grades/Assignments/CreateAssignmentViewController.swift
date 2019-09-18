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
        setupChildSwitchSection()
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
        nameDescriptionLabel.text = "Enter a name for the assignment".localized
        nameTextField.placeholder = "Assignment name".localized
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
        datePickerTextField.delegate = self
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(dateDescriptionLabel)
        contentView.addSubview(datePickerTextField)
        
        setupLabelConstraints(for: dateLabel, topAnchor: testView.bottomAnchor, topConstant: titleTopConstant)
        setupLabelConstraints(for: dateDescriptionLabel, topAnchor: dateLabel.bottomAnchor, topConstant: descriptionTopConstant)
        datePickerTextField.anchor
            .top(to: dateDescriptionLabel.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
    }
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createAssignment), for: .touchUpInside)
        addButton.color = UIColor(named: "accendColor")
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
    
    @objc private func switchValueChanged(_ childsSwitch: UISwitch) {
        testHeightAnchor?.constant = childsSwitch.isOn ? 100 : 0
        UIView.animate(withDuration: 0.3) {
            self.testView.alpha = childsSwitch.isOn ? 1 : 0
            self.view.layoutIfNeeded()
        }
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
        if nameTextField.isEmpty
            || minGradeTextField.isEmpty
            || maxGradeTextField.isEmpty
            || percentageTextField.isEmpty
            || datePickerTextField.isEmpty {
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
            let date = datePickerTextField.date,
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
                assignment.deadline = date
                
                if self.assignment != nil {
                    self.assignment = assignment
                } else {
                    let service = AbstractServiceFactory.getServiceFactory(for: .realm)
                    service.assignmentService.createAssignment(assignment) { result in
                        switch result {
                        case .success(let assignment):
                            self.createNotification(for: assignment.copy() as! Assignment, subjectName: self.subject.name)
                        case .failure(let error):
                            print(error)
                        }
                        
                    }
                }
                
                dismissView()
                delegate?.didCreateAssignment()
            }
        }
    }
    
    private func createNotification(for assignment: Assignment, subjectName: String) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            
            if settings.alertSetting == .enabled {
                self.scheduleNotification(for: assignment, subjectName: subjectName, notificationCenter: center)
            } else {
                
            }
        }
    }
    
    private func scheduleNotification(for assignment: Assignment, subjectName: String, notificationCenter center: UNUserNotificationCenter) {
        if assignment.deadline > Date() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let day = dateFormatter.string(from: assignment.deadline)
            dateFormatter.dateFormat = "h:mma"
            let time = dateFormatter.string(from: assignment.deadline)
            
            let content = UNMutableNotificationContent()
            content.title = "\(assignment.name) of \(subjectName)"
            content.body = "You have \(assignment.name) on \(day) at \(time)"
            content.sound = .default
            
            let date = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: assignment.deadline)
            let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
            let identifier = assignment.id
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
    
    private func valuesAreValid(maxGrade: Float, minGrade: Float, grade: Float, percentage: Float) -> Bool {
        if maxGrade <= 0 || minGrade < 0 || grade < 0 {
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
            return false
        }
        
        if percentage > 100 {
            percentageTextField.showErrorBorder()
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

