//
//  AssignmentTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell, ReusableView {

    /// The radius of the graph
    private let circleRadius: CGFloat = 26
    /// Margin for leading and trailing
    private let margin: CGFloat = 16
    private var progressRingView: ProgressRingView!
    /// Label for the qualificationable's name
    private let nameLabel: IPLabel = {
        let label = IPLabel()
        label.text = "Name"
        return label
    }()
    private let dateLabel: IPLabel = {
        let label = IPLabel()
        label.text = "Date:"
        label.textColor = ThemeManager.currentTheme.placeholderColor
        return label
    }()
    private let containerView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds all the components to the view
    private func initialize() {
        selectionStyle = .none
        setupContainerView()
        
        containerView.addSubview(nameLabel)
        nameLabel.anchor
            .topToSuperview(constant: margin)
            .leadingToSuperview(constant: margin)
            .activate()
        
        containerView.addSubview(dateLabel)
        dateLabel.anchor
            .top(to: nameLabel.bottomAnchor, constant: 5)
            .leadingToSuperview(constant: margin)
            .bottomToSuperview(constant: -margin)
            .trailing(to: nameLabel.trailingAnchor)
            .activate()
        
        
        progressRingView = ProgressRingView(radius: circleRadius)
        containerView.addSubview(progressRingView)
        progressRingView.anchor
            .trailingToSuperview(constant: -margin)
            .leading(to: nameLabel.trailingAnchor, constant: margin)
            .centerYToSuperview(constant: 5)
            .activate()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 4, left: 16, bottom: -4, right: -16))
            .activate()
    }
    
    
    /// Configures the cell with the qualificationable information and adds the semi-circle that is in the front
    ///
    /// - Parameter qualificationable: Qualificationable to be displayed
    func configure(with qualificationable: Qualificationable) {
        nameLabel.text = qualificationable.name
        
        progressRingView.removeFromSuperview()
        progressRingView = ProgressRingView(radius: circleRadius)
        containerView.addSubview(progressRingView)
        progressRingView.anchor
            .trailingToSuperview(constant: -margin)
            .leading(to: nameLabel.trailingAnchor, constant: margin)
            .centerYToSuperview(constant: 5)
            .activate()
        progressRingView.configure(with: qualificationable)
    }

}
