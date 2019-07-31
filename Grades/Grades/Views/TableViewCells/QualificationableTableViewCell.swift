//
//  QualificationableTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class QualificationableTableViewCell: UITableViewCell, ReusableView {
    
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
        
        progressRingView = ProgressRingView(radius: circleRadius)
        containerView.addSubview(progressRingView)
        progressRingView.anchor
            .trailingToSuperview(constant: -margin)
            .centerYToSuperview(constant: 5)
            .activate()
        
        containerView.addSubview(nameLabel)
        nameLabel.anchor
            .leadingToSuperview(constant: margin)
            .trailingToSuperview(constant: -margin)
            .centerYToSuperview()
            .activate()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 4, left: 16, bottom: -4, right: -16))
            .height(constant: 70)
            .activate()
    }
    
    
    /// Configures the cell with the qualificationable information and adds the semi-circle that is in the front
    ///
    /// - Parameter qualificationable: Qualificationable to be displayed
    func configure(with qualificationable: Qualificationable) {
        nameLabel.text = qualificationable.name
        progressRingView.configure(with: qualificationable)
    }
    
}
