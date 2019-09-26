//
//  EventView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell, ReusableView {

    let titleLabel: UILabel = UILabel()
    let dateTimeLabel: UILabel = UILabel()
    let dateFormatter = DateFormatter()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {
        selectionStyle = .none
        // accessoryType = .disclosureIndicator
        let contentView: UIView = UIView()
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 10
        addSubview(contentView)
        
        let divider = UIView()
        divider.backgroundColor = UIColor.accentColor
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(divider)
        contentView.addSubview(dateTimeLabel)
        
        contentView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16))
            .activate()
        
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        contentView.addSubview(titleLabel)
        titleLabel.anchor
            .topToSuperview(constant: 16)
            .leadingToSuperview(constant: 16)
            .trailingToSuperview(constant: -16)
            .activate()
        
        divider.anchor
            .top(to: dateTimeLabel.topAnchor)
            .leadingToSuperview(constant: 16)
            .trailing(to: dateTimeLabel.leadingAnchor, constant: -5)
            .bottom(to: dateTimeLabel.bottomAnchor)
            .width(constant: 2)
            .activate()
        
        dateTimeLabel.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .trailingToSuperview(constant: -16)
            .bottomToSuperview(constant: -16)
            .activate()
    }
    
    func configure(with assignment: Assignment) {
        titleLabel.text = "\(assignment.name) - \(assignment.subject?.name ?? "")"
        dateTimeLabel.text = dateFormatter.string(from: assignment.deadline, format: .dateAndTime)
    }
}
