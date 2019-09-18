//
//  BarChartTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BarChartTableViewCell: UITableViewCell, ReusableView {
    
    let minimumHeight: CGFloat = 90
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        selectionStyle = .none
        let containerView = UIView()
        containerView.backgroundColor = .systemGray5
        containerView.layer.cornerRadius = 10
        addSubview(containerView)
        
        containerView.anchor
            .topToSuperview(constant: 4)
            .trailingToSuperview(constant: -margin, toSafeArea: true)
            .bottomToSuperview(constant: -4)
            .leadingToSuperview(constant: margin, toSafeArea: true)
            .height(greaterThanOrEqualToConstant: minimumHeight)
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

    
    func configure(with items: [Gradable]) {
        chartStackView.removeAllArrangedSubviews()
        namesStackView.removeAllArrangedSubviews()
        for (index, item) in items.enumerated() {
            setupChartBar(with: item, at: index)
            setupBarName(item.name, at: index)
        }
    }
    
    private func setupChartBar(with item: Gradable, at index: Int) {
        let containerView = UIView()
        
        let backView = UIView()
        backView.backgroundColor = .systemGray3
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = false
        
        containerView.addSubview(backView)
        backView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
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

        topView.anchor
            .height(to: backView.heightAnchor, multiplier: CGFloat(item.grade / item.maxGrade))
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

