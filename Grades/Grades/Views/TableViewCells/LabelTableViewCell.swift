//
//  LabelTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/30/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell, ReusableView {
    
    private let margin: CGFloat = 16
    private let containerView: UIView = UIView()
    var nameLabel: IPLabel = {
        let label = IPLabel()
        label.text = "Term Name"
        return label
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
        setupContainerView()
        containerView.addSubview(nameLabel)
        nameLabel.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: margin, left: 3 * margin, bottom: -margin, right: -margin))
            .activate()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .systemGray5
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8))
            .height(constant: 70)
            .activate()
    }
    
}
