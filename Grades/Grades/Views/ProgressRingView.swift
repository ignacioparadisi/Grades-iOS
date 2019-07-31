//
//  ProgressRingView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class ProgressRingView: UIView {
    
    /// The start angle of the qualification graph
    private let circleStartAngle: CGFloat = 5/6 * CGFloat.pi
    /// The end angle of the qualification graph
    private let circleEndAngle: CGFloat = 13/6 * CGFloat.pi
    /// The qualification is multiplied by this angle to place the graph in the correct place
    private let constantAngle: CGFloat = 4/3 * CGFloat.pi
    /// The radius of the graph
    private var circleRadius: CGFloat = 26
    private let lineWidth: CGFloat = 5
    private let chartContainer = UIView()
    /// Label for the subject's qualification
    private let qualificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = ThemeManager.currentTheme.textColor
        return label
    }()

    init(radius: CGFloat) {
        super.init(frame: .zero)
        circleRadius = radius
        setpuView()  
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setpuView() {
        chartContainer.backgroundColor = .clear
        addSubview(chartContainer)
        chartContainer.anchor
            .height(constant: circleRadius * 2)
            .width(constant: circleRadius * 2)
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
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
        backgroundShapeLayer.lineWidth = lineWidth
        backgroundShapeLayer.lineCap = .round
        chartContainer.layer.addSublayer(backgroundShapeLayer)
    }
    
    func configure(with qualificationable: Qualificationable) {
        qualificationLabel.text = "\(Int(qualificationable.qualification.rounded()))"
        
        let frontShapeLayer = CAShapeLayer()
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let circularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleStartAngle + constantAngle * CGFloat(qualificationable.qualification / qualificationable.maxQualification), clockwise: true)
        frontShapeLayer.path = circularPath.cgPath
        frontShapeLayer.fillColor = UIColor.clear.cgColor
        frontShapeLayer.strokeColor = UIColor.getColor(for: qualificationable).cgColor
        frontShapeLayer.lineWidth = lineWidth
        frontShapeLayer.strokeEnd = 0
        frontShapeLayer.lineCap = .round
        chartContainer.layer.addSublayer(frontShapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 1
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        frontShapeLayer.add(basicAnimation, forKey: "animation")
    }
    
}
