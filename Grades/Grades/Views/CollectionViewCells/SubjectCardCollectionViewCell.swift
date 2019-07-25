//
//  SubjectCardCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectCardCollectionViewCell: UICollectionViewCell, ReusableView {
    
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
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = ThemeManager.currentTheme.textColor
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
    private let graphContainer = UIView()
    /// Subjects to be displayed
    var subject: Subject = Subject()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Adds all the components to the view
    private func initialize() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex: 0x707070)
        addSubview(bottomLine)
        bottomLine.anchor
            .trailing(to: trailingAnchor)
            .bottom(to: bottomAnchor)
            .leading(to: leadingAnchor, constant: margin)
            .height(constant: 1)
            .activate()

        addSubview(nameLabel)
        nameLabel.anchor
            .top(to: topAnchor)
            .leading(to: leadingAnchor, constant: margin)
            .bottom(to: bottomAnchor, constant: -10)
            .centerY(to: centerYAnchor)
            .activate()
        
        drawCircle()
    }
    
    
    /// Draws the semi-circle of the graph that is in the back
    private func drawCircle() {
        graphContainer.backgroundColor = .clear
        addSubview(graphContainer)
        graphContainer.anchor
            .height(constant: circleRadius * 2)
            .width(constant: circleRadius * 2)
            .trailing(to: trailingAnchor, constant: -margin)
            .centerY(to: centerYAnchor)
            .activate()
        
        
        graphContainer.addSubview(qualificationLabel)
        qualificationLabel.anchor
            .centerX(to: graphContainer.centerXAnchor)
            .centerY(to: graphContainer.centerYAnchor)
            .activate()
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let backgroundShapeLayer = CAShapeLayer()
        let backgroundCircularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleEndAngle, clockwise: true)
        backgroundShapeLayer.path = backgroundCircularPath.cgPath
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.strokeColor = UIColor(hex: 0x707070).cgColor
        backgroundShapeLayer.lineWidth = 2
        backgroundShapeLayer.lineCap = .round
        graphContainer.layer.addSublayer(backgroundShapeLayer)
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
            graphContainer.layer.addSublayer(frontShapeLayer)
            
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
