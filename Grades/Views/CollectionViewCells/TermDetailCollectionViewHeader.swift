//
//  TermDetailCollectionViewHeader.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol TermDetailCollectionViewHeaderDelegate: class {
    func dismissView()
}

class TermDetailCollectionViewHeader: UICollectionReusableView, ReusableView {
    
    let qualificationContainerDiameter: CGFloat = 80.0
    let minMaxQualificationContainerDiameter: CGFloat = 60.0
    weak var delegate: TermDetailCollectionViewHeaderDelegate?
    let qualificationLabel = IPTitleLabel()
    let minQualificationLabel = IPLabel()
    let maxQualificationLabel = IPLabel()
    
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
        
        setupQualificationContainer()
        
        let minQualificationContainer = setupMinMaxQualificationContainer(label: minQualificationLabel, description: "Min. Qualification")
        minQualificationContainer.anchor
            .centerX(to: centerXAnchor, constant: -frame.width / 4 - (qualificationContainerDiameter - minMaxQualificationContainerDiameter))
            .activate()
        
        let maxQualificationContainer = setupMinMaxQualificationContainer(label: maxQualificationLabel, description: "Max. Qualification")
        maxQualificationContainer.anchor
            .centerX(to: centerXAnchor, constant: frame.width / 4 + (qualificationContainerDiameter - minMaxQualificationContainerDiameter))
            .activate()
        
    }
    
    private func setupQualificationContainer() {
        let qualificationContainer = UIView()
        addSubview(qualificationContainer)
        qualificationContainer.anchor
            .height(constant: qualificationContainerDiameter)
            .width(to: qualificationContainer.heightAnchor)
            .centerToSuperview()
            .activate()
        qualificationContainer.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        qualificationContainer.layer.cornerRadius = qualificationContainerDiameter / 2
        
        qualificationContainer.addSubview(qualificationLabel)
        qualificationLabel.anchor.centerToSuperview().activate()
        qualificationLabel.text = "0"
    }
    
    private func setupMinMaxQualificationContainer(label: UILabel, description: String) -> UIView {
        let view = UIView()
        let descriptionLabel = IPLabel()
        descriptionLabel.font = ThemeManager.currentTheme.font(style: .regular, size: 10)
        descriptionLabel.text = description
        addSubview(view)
        view.anchor
            .height(constant: minMaxQualificationContainerDiameter)
            .width(to: view.heightAnchor)
            .centerYToSuperview()
            .activate()
        view.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        view.layer.cornerRadius = minMaxQualificationContainerDiameter / 2
        
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
    
    func configureWith(_ qualificationable: Qualificationable) {
        qualificationLabel.text = "\(qualificationable.qualification)"
        minQualificationLabel.text = "\(qualificationable.minQualification)"
        maxQualificationLabel.text = "\(qualificationable.maxQualification)"
        
        backgroundColor = UIColor.getColor(for: qualificationable)
    }
    
    @objc private func dismissView() {
        delegate?.dismissView()
    }

}