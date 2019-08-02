//
//  Header.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class DetailHeader: UIView {
    
    let gradeContainerDiameter: CGFloat = 80.0
    let minMaxGradeContainerDiameter: CGFloat = 60.0
    let gradeLabel = IPTitleLabel()
    let minGradeLabel = IPLabel()
    let maxGradeLabel = IPLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = ThemeManager.currentTheme.greenColor
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.30
        
        setupGradeContainer()
        
        let minGradeContainer = setupMinMaxGradeContainer(label: minGradeLabel, description: "Min. Grade")
        minGradeContainer.anchor
            .centerX(to: centerXAnchor, constant: -frame.width / 4 - (gradeContainerDiameter - minMaxGradeContainerDiameter))
            .activate()
        
        let maxGradeContainer = setupMinMaxGradeContainer(label: maxGradeLabel, description: "Max. Grade")
        maxGradeContainer.anchor
            .centerX(to: centerXAnchor, constant: frame.width / 4 + (gradeContainerDiameter - minMaxGradeContainerDiameter))
            .activate()
        
    }
    
    private func setupGradeContainer() {
        let gradeContainer = UIView()
        addSubview(gradeContainer)
        gradeContainer.anchor
            .height(constant: gradeContainerDiameter)
            .width(to: gradeContainer.heightAnchor)
            .centerToSuperview()
            .activate()
        gradeContainer.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        gradeContainer.layer.cornerRadius = gradeContainerDiameter / 2
        
        gradeContainer.addSubview(gradeLabel)
        gradeLabel.anchor.centerToSuperview().activate()
        gradeLabel.text = "0"
    }
    
    private func setupMinMaxGradeContainer(label: UILabel, description: String) -> UIView {
        let view = UIView()
        let descriptionLabel = IPLabel()
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        descriptionLabel.text = description
        addSubview(view)
        view.anchor
            .height(constant: minMaxGradeContainerDiameter)
            .width(to: view.heightAnchor)
            .centerYToSuperview()
            .activate()
        view.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        view.layer.cornerRadius = minMaxGradeContainerDiameter / 2
        
        view.addSubview(label)
        label.anchor.centerToSuperview().activate()
        label.text = "0"
        
        addSubview(descriptionLabel)
        descriptionLabel.anchor
            .top(to: view.bottomAnchor, constant: 5)
            .centerX(to: view.centerXAnchor)
            .activate()
        return view
    }
    
    func configure(with gradable: Gradable) {
        gradeLabel.text = "\(Int(gradable.grade.rounded()))"
        minGradeLabel.text = "\(Int(gradable.minGrade.rounded()))"
        maxGradeLabel.text = "\(Int(gradable.maxGrade.rounded()))"
        
        backgroundColor = UIColor.getColor(for: gradable)
    }

    
}
