//
//  BarChartCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/17/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BarChartCollectionViewCell: UICollectionViewCell, ReusableView {
    
    let margin: CGFloat = 16
    var chartStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        return stackView
    }()
    var namesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.spacing = 5.0
        return stackView
    }()
    var widthConstraints: [NSLayoutConstraint] = []
    var isExpanded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let containerView = UIView()
        containerView.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        containerView.layer.cornerRadius = 10
        addSubview(containerView)
        
        containerView.anchor
            .topToSuperview(constant: margin)
            .trailingToSuperview(constant: -margin, toSafeArea: true)
            .bottomToSuperview()
            .leadingToSuperview(constant: margin, toSafeArea: true)
            .activate()
        
        containerView.addSubview(chartStackView)
        chartStackView.anchor
            .topToSuperview(constant: margin)
            .trailingToSuperview(constant: -margin)
            .bottomToSuperview(constant: -margin)
            .activate()
        
        containerView.addSubview(namesStackView)
        namesStackView.anchor
            .topToSuperview(constant: margin)
            .trailing(to: chartStackView.leadingAnchor, constant: -margin)
            .bottomToSuperview(constant: -margin)
            .leadingToSuperview(constant: margin)
            .activate()
    }
    
    
    func configure(with items: [Qualificationable]) {
        chartStackView.removeAllArrangedSubviews()
        namesStackView.removeAllArrangedSubviews()
        for (index, item) in items.enumerated() {
            setupChartBar(with: item, at: index)
            setupBarName(item.name, at: index)
        }
    }
    
    private func setupChartBar(with item: Qualificationable, at index: Int) {
        let containerView = UIView()
        
        let backView = UIView()
        backView.backgroundColor = UIColor(hex: 0x707070)
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = false
        
        containerView.addSubview(backView)
        backView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        let constraint = backView.widthAnchor.constraint(equalToConstant: 30)
        widthConstraints.append(constraint)
        
        let numberLabel = IPLabel()
        numberLabel.text = "\(index + 1)"
        numberLabel.textAlignment = .center
        
        containerView.addSubview(numberLabel)
        numberLabel.anchor
            .top(to: backView.bottomAnchor, constant: 10)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        
        let topView = UIView()
        topView.backgroundColor = UIColor.getColor(for: item)
        topView.layer.cornerRadius = 5
        topView.layer.masksToBounds = false
        backView.addSubview(topView)
        
        let barHeight = frame.height - (5 * margin) - (frame.height - (5 * margin)) * CGFloat(item.qualification / item.maxQualification)
        topView.anchor
            .topToSuperview(constant: barHeight)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        chartStackView.addArrangedSubview(containerView)
    }
    
    private func setupBarName(_ name: String, at index: Int) {
        let nameLabel = IPLabel()
        nameLabel.text = "\(index + 1). \(name)"
        nameLabel.numberOfLines = 2
        
        namesStackView.addArrangedSubview(nameLabel)
    }
    
}
