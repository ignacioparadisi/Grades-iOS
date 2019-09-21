//
//  AssignmentTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell, ReusableView {

    private let separatorWidth: CGFloat = 2
    /// The radius of the graph
    private let circleRadius: CGFloat = 26
    /// Margin for leading and trailing
    private let margin: CGFloat = 16
    private var progressRingView: ProgressRingView!
    /// Label for the gradable's name
    private let nameLabel: IPLabel = {
        let label = IPLabel()
        label.text = "Name"
        return label
    }()
    private let dateLabel: IPLabel = {
        let label = IPLabel()
        return label
    }()
    private let containerView = UIView()
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
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
        separator.layer.cornerRadius = separatorWidth / 2
        setupContainerView()
        
        containerView.addSubview(nameLabel)
        nameLabel.anchor
            .topToSuperview(constant: margin)
            .leadingToSuperview(constant: margin)
            .activate()
        
        containerView.addSubview(separator)
        containerView.addSubview(dateLabel)
        
        separator.anchor
            .top(to: nameLabel.bottomAnchor, constant: 5)
            .bottomToSuperview(constant: -margin)
            .leadingToSuperview(constant: margin)
            .width(constant: separatorWidth)
            .activate()
        dateLabel.anchor
            .top(to: nameLabel.bottomAnchor, constant: 5)
            .leading(to: separator.trailingAnchor, constant: 8)
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
        containerView.backgroundColor = .systemGray5
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 4, left: 16, bottom: -4, right: -16))
            .activate()
    }
    
    
    /// Configures the cell with the gradable information and adds the semi-circle that is in the front
    ///
    /// - Parameter gradable: Gradable to be displayed
    func configure(with assignment: Assignment) {
        if assignment.deadline >= Date() {
            separator.backgroundColor = UIColor(named: "accentColor")
        } else {
            separator.backgroundColor = .systemGray2
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mma"
        nameLabel.text = assignment.name
        dateLabel.text = "\(dateFormatter.string(from: assignment.deadline))"
        
        progressRingView.removeFromSuperview()
        progressRingView = ProgressRingView(radius: circleRadius)
        containerView.addSubview(progressRingView)
        progressRingView.anchor
            .trailingToSuperview(constant: -margin)
            .leading(to: nameLabel.trailingAnchor, constant: margin)
            .centerYToSuperview(constant: 5)
            .activate()
        progressRingView.configure(with: assignment)
    }

}
