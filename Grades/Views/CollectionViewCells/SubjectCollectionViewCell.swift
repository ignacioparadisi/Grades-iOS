//
//  SubjectCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let circleStartAngle: CGFloat = 5/6 * CGFloat.pi
    private let circleEndAngle: CGFloat = 13/6 * CGFloat.pi
    private let constantAngle: CGFloat = 4/3 * CGFloat.pi
    private let circleRadius: CGFloat = 26
    private let rightMargin: CGFloat = 16
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.font = ThemeManager.currentTheme.font(style: .regular, size: 17)
        label.textColor = ThemeManager.currentTheme.textColor
        label.text = "Subject Name"
        return label
    }()
    private let qualificationLabel: UILabel = {
        let label = UILabel()
        label.font = ThemeManager.currentTheme.font(style: .regular, size: 20)
        label.textColor = ThemeManager.currentTheme.textColor
        return label
    }()
    private let graphContainer = UIView()
    var subject: Subject = Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10)// Subject()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(hex: 0x707070)
        addSubview(bottomLine)
        bottomLine.anchor
            .trailing(to: trailingAnchor, constant: -16)
            .bottom(to: bottomAnchor)
            .leading(to: leadingAnchor, constant: 16)
            .height(constant: 1)
            .activate()

        addSubview(nameLabel)
        nameLabel.anchor
            .top(to: topAnchor)
            .leading(to: leadingAnchor, constant: 16)
            .bottom(to: bottomAnchor, constant: -10)
            .centerY(to: centerYAnchor)
            .activate()
        
        drawCircle()
    }
    
    private func drawCircle() {
        graphContainer.backgroundColor = .clear
        addSubview(graphContainer)
        graphContainer.anchor
            .height(constant: circleRadius * 2)
            .width(constant: circleRadius * 2)
            .trailing(to: trailingAnchor, constant: -16)
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
    
    func configureWith(subject: Subject) {
        nameLabel.text = subject.name
        qualificationLabel.text = "\(Int(subject.qualification.rounded()))"
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let shapeLayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleStartAngle + constantAngle * CGFloat(subject.qualification / subject.maxQualification), clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = ThemeManager.currentTheme.greenColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = .round
        graphContainer.layer.addSublayer(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "animation")
    }
    
    
    
}
