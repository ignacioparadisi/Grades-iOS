//
//  AddTermViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AddTermViewController: BaseViewController, ScrollableView {
    
    let titleTopConstant: CGFloat = 20.0
    let descriptionTopConstant: CGFloat = 5.0
    let fieldTopConstant: CGFloat = 10.0
    let trailingConstant: CGFloat = -16.0
    let leadingConstant: CGFloat = 16.0
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
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupNameSection()
        setupQualificationsSection()
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
        let qualificationDescription = IPLabel()
        
        qualificationsLabel.text = "Qualifications".localized
        qualificationDescription.text = "Enter max and min qualification to pass".localized
        maxQualificationTextField.placeholder = "Max. Qualification".localized
        minQualificationTextField.placeholder = "Min. Qualification".localized
        
        contentView.addSubview(qualificationsLabel)
        contentView.addSubview(qualificationDescription)
        contentView.addSubview(minQualificationTextField)
        contentView.addSubview(maxQualificationTextField)
        
        qualificationsLabel.anchor
            .top(to: nameTextField.bottomAnchor, constant: titleTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        qualificationDescription.anchor
            .top(to: qualificationsLabel.bottomAnchor, constant: descriptionTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        minQualificationTextField.anchor
            .top(to: qualificationDescription.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.centerXAnchor, constant: trailingConstant / 2)
            .leading(to: contentView.leadingAnchor, constant: leadingConstant)
            .activate()
        maxQualificationTextField.anchor
            .top(to: qualificationDescription.bottomAnchor, constant: fieldTopConstant)
            .trailing(to: contentView.trailingAnchor, constant: trailingConstant)
            .leading(to: contentView.centerXAnchor, constant: leadingConstant / 2)
            .activate()
    }
    
    private func setupSaveButton() {
        addButton.setTitle("Save".localized, for: .normal)
        addButton.addTarget(self, action: #selector(createTerm), for: .touchUpInside)
        addButton.color = ThemeManager.currentTheme.accentColor
        contentView.addSubview(addButton)
        addButton.anchor
            .bottom(to: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            .trailing(to: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
            .leading(to: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            .activate()
    }
    
    @objc private func createTerm() {
        dismissView()
    }

}
