//
//  HeaderCollectionReusableView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, ReusableView {
    
    let path = UIBezierPath()
    let qualificationContainerDiameter: CGFloat = 60
    let termNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme.textColor
        label.font = ThemeManager.currentTheme.font(style: .medium, size: 25)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let qualificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = ThemeManager.currentTheme.textColor
        label.font = ThemeManager.currentTheme.font(style: .medium, size: 25)
        label.textAlignment = .center
        label.text = "17"
        return label
    }()
    
    var term: Term = Term();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = .clear
        
        let nameLabelContainer = UIView()
        nameLabelContainer.backgroundColor = .clear
        addSubview(nameLabelContainer)
        nameLabelContainer.addSubview(termNameLabel)
        
        termNameLabel.anchor
            .leading(to: nameLabelContainer.leadingAnchor, constant: 16)
            .trailing(to: nameLabelContainer.trailingAnchor, constant: -16)
            .centerX(to: nameLabelContainer.centerXAnchor)
            .centerY(to: nameLabelContainer.centerYAnchor)
            .activate()

        let qualificationContainer = UIView()
        addSubview(qualificationContainer)
        qualificationContainer.anchor
            .height(constant: qualificationContainerDiameter)
            .width(to: qualificationContainer.heightAnchor)
            .bottom(to: bottomAnchor, constant: -4)
            .centerX(to: centerXAnchor)
            .activate()
        qualificationContainer.backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        qualificationContainer.layer.cornerRadius = qualificationContainerDiameter / 2

        qualificationContainer.addSubview(qualificationLabel)
        qualificationLabel.anchor
            .centerX(to: qualificationContainer.centerXAnchor)
            .centerY(to: qualificationContainer.centerYAnchor)
            .activate()
        
        nameLabelContainer.anchor
            .top(to: topAnchor, constant: 20)
            .leading(to: leadingAnchor)
            .trailing(to: trailingAnchor)
            .bottom(to: qualificationContainer.topAnchor, constant: -20)
            .activate()
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.30
    }
    
    override func draw(_ rect: CGRect) {
        let size = self.bounds.size
        let height = size.height * 0.80

        // calculate the 5 points of the pentagon
        let topLeftCorner = self.bounds.origin
        let topRightCorner = CGPoint(x: topLeftCorner.x + size.width, y: topLeftCorner.y)
        let bottomRightCorner = CGPoint(x: topRightCorner.x, y: topRightCorner.y + height)
        let bottomCenter = CGPoint(x: size.width / 2, y: size.height)
        let bottomLeftCorner = CGPoint(x: topLeftCorner.x, y: height)

        // create the path
        path.move(to: topLeftCorner)
        path.addLine(to: topRightCorner)
        path.addLine(to: bottomRightCorner)
        path.addLine(to: bottomCenter)
//        path.addLine(to: bottomRightCenter)
//        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height - 10), radius: 10, startAngle: CGFloat.pi / 3, endAngle: (2/3)*CGFloat.pi, clockwise: true)
//        path.addLine(to: bottomLeftCenter)
        path.addLine(to: bottomLeftCorner)
        path.close()
        fill()
    }
    
    public func configureWith(term: Term) {
       
        self.term = term
        termNameLabel.text = term.name
        qualificationLabel.text = "\(Int(term.qualification.rounded()))"
        draw(frame)
        
    }
    
    private func fill() {
        // fill the path
        let roundedQualification = term.qualification.rounded()
        if roundedQualification <= 20, roundedQualification > 15 {
            ThemeManager.currentTheme.greenColor.set()
            path.fill()
        } else if roundedQualification <= 15, roundedQualification > 9 {
            ThemeManager.currentTheme.yellowColor.set()
            path.fill()
        } else {
            ThemeManager.currentTheme.redColor.set()
            path.fill()
        }
    }
    
}
