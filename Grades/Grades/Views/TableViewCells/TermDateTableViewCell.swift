//
//  TermDateTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 8/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermDateTableViewCell: UITableViewCell, ReusableView {

    private let separatorWidth: CGFloat = 2
    private let margin: CGFloat = 16
    private let startDateLabel: IPLabel = {
        let label = IPLabel()
        label.textAlignment = .center
        return label
    }()
    private let endDateLabel: IPLabel = {
        let label = IPLabel()
        label.textAlignment = .center
        return label
    }()
    private let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        selectionStyle = .none
        isUserInteractionEnabled = false
        
        let separator = UIView()
        separator.backgroundColor = UIColor(hex: 0x707070)
        separator.layer.cornerRadius = separatorWidth / 2
        
        let containerView = UIView()
        containerView.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        containerView.layer.cornerRadius = 10
        
        addSubview(containerView)
        containerView.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16)).activate()
        
        containerView.addSubview(startDateLabel)
        containerView.addSubview(separator)
        containerView.addSubview(endDateLabel)
        
        startDateLabel.anchor
            .topToSuperview(constant: margin)
            .trailing(to: containerView.centerXAnchor, constant: -margin)
            .bottomToSuperview(constant: -margin)
            .leadingToSuperview(constant: margin)
            .activate()
        
        separator.anchor
            .centerXToSuperview()
            .topToSuperview(constant: margin)
            .bottomToSuperview(constant: -margin)
            .width(constant: separatorWidth)
            .activate()
        
        endDateLabel.anchor
            .topToSuperview(constant: margin)
            .trailingToSuperview(constant: -margin)
            .bottomToSuperview(constant: -margin)
            .leading(to: containerView.centerXAnchor, constant: margin)
            .activate()
    }
    
    func configure(startDate: Date, endDate: Date) {
        startDateLabel.text = dateFormatter.string(from: startDate)
        endDateLabel.text = dateFormatter.string(from: endDate)
    }
}
