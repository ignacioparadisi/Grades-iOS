//
//  ProgressRingView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 7/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class ProgressRingView: UIView {
    
    /// The start angle of the grade graph
    private let circleStartAngle: CGFloat = 5/6 * CGFloat.pi
    /// The end angle of the grade graph
    private let circleEndAngle: CGFloat = 13/6 * CGFloat.pi
    /// The grade is multiplied by this angle to place the graph in the correct place
    private let constantAngle: CGFloat = 4/3 * CGFloat.pi
    /// The radius of the graph
    private var circleRadius: CGFloat = 26
    private let lineWidth: CGFloat = 5
    private let chartContainer = UIView()
    /// Label for the subject's grade
    private let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
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
        
        
        chartContainer.addSubview(gradeLabel)
        gradeLabel.anchor
            .centerX(to: chartContainer.centerXAnchor)
            .centerY(to: chartContainer.centerYAnchor)
            .activate()
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let backgroundShapeLayer = CAShapeLayer()
        let backgroundCircularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleEndAngle, clockwise: true)
        backgroundShapeLayer.path = backgroundCircularPath.cgPath
        backgroundShapeLayer.fillColor = UIColor.clear.cgColor
        backgroundShapeLayer.strokeColor = UIColor.systemGray3.cgColor
        backgroundShapeLayer.lineWidth = lineWidth
        backgroundShapeLayer.lineCap = .round
        chartContainer.layer.addSublayer(backgroundShapeLayer)
    }
    
    func configure(with gradable: Gradable) {
        gradeLabel.text = "\(Int(gradable.grade.rounded()))"
        
        let frontShapeLayer = CAShapeLayer()
        
        let circleCenter = CGPoint(x: circleRadius, y: circleRadius)
        
        let circularPath = UIBezierPath(arcCenter: circleCenter, radius: circleRadius, startAngle: circleStartAngle, endAngle: circleStartAngle + constantAngle * CGFloat(gradable.grade / gradable.maxGrade), clockwise: true)
        frontShapeLayer.path = circularPath.cgPath
        frontShapeLayer.fillColor = UIColor.clear.cgColor
        frontShapeLayer.strokeColor = UIColor.getColor(for: gradable).cgColor
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
