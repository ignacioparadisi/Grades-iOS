//
//  SubjectTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectTableViewCell: UITableViewCell, ReusableView {
    
    /// The start angle of the qualification graph
    private let circleStartAngle: CGFloat = 5/6 * CGFloat.pi
    /// The end angle of the qualification graph
    private let circleEndAngle: CGFloat = 13/6 * CGFloat.pi
    /// The qualification is multiplied by this angle to place the graph in the correct place
    private let constantAngle: CGFloat = 4/3 * CGFloat.pi
    /// The radius of the graph
    private let circleRadius: CGFloat = 26
    /// Margin for leading and trailing
    private let margin: CGFloat = 16
    /// Label for the subject's name
    private let nameLabel: IPLabel = {
        let label = IPLabel()
        label.text = "Subject Name"
        return label
    }()
    /// Label for the subject's qualification
    private let qualificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = ThemeManager.currentTheme.textColor
        return label
    }()
    /// Clear view that contains the graph
    private let chartContainer = UIView()
    private let containerView = UIView()
    /// Subjects to be displayed
    var subject: Subject = Subject()
    
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
            .leading(to: containerView.leadingAnchor, constant: margin)
            .centerY(to: containerView.centerYAnchor)
            .activate()
        
        drawCircle()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = false
        
        addSubview(containerView)
        containerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 16, bottom: -8, right: -16))
            .height(constant: 70)
            .activate()
    }
    
    
    /// Draws the semi-circle of the graph that is in the back
    private func drawCircle() {
        chartContainer.backgroundColor = .clear
        containerView.addSubview(chartContainer)
        chartContainer.anchor
            .height(constant: circleRadius * 2)
            .width(constant: circleRadius * 2)
            .trailing(to: containerView.trailingAnchor, constant: -margin)
            .centerY(to: containerView.centerYAnchor, constant: 5)
            .activate()
        
        
        chartContainer.addSubview(qualificationLabel)
        qualificationLabel.anchor
            .centerX(to: chartContainer.centerXAnchor)
            .centerY(to: chartContainer.centerYAnchor)
            .activate()
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let backgroundShapeLayer = CAShapeLayer()
        let backgroundCircularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleEndAngle, clockwise: true)
        backgroundShapeLayer.path = backgroundCircularPath.cgPath
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.strokeColor = UIColor(hex: 0x707070).cgColor
        backgroundShapeLayer.lineWidth = 2
        backgroundShapeLayer.lineCap = .round
        chartContainer.layer.addSublayer(backgroundShapeLayer)
    }
    
    
    /// Configures the cell with the subject information and adds the semi-circle that is in the front
    ///
    /// - Parameter subject: Subject to be displayed
    func configure(with subject: Subject) {
        nameLabel.text = subject.name
        qualificationLabel.text = "\(Int(subject.qualification.rounded()))"
        
        if subject.shouldDraw {
            let frontShapeLayer = CAShapeLayer()
            
            let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
            
            let circularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleStartAngle + constantAngle * CGFloat(subject.qualification / subject.maxQualification), clockwise: true)
            frontShapeLayer.path = circularPath.cgPath
            frontShapeLayer.fillColor = UIColor.clear.cgColor
            frontShapeLayer.strokeColor = UIColor.getColor(for: subject).cgColor
            frontShapeLayer.lineWidth = 2
            frontShapeLayer.strokeEnd = 0
            frontShapeLayer.lineCap = .round
            chartContainer.layer.addSublayer(frontShapeLayer)
            
            let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
            basicAnimation.toValue = 1
            basicAnimation.duration = 1
            basicAnimation.fillMode = .forwards
            basicAnimation.isRemovedOnCompletion = false
            frontShapeLayer.add(basicAnimation, forKey: "animation")
            
            subject.shouldDraw = false
        }
    }
    
}
