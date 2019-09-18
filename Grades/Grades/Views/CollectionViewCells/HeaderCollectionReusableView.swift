//
//  HeaderCollectionReusableView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView, ReusableView {
    
    let gradeContainerDiameter: CGFloat = 60
    let termNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
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

        let gradeContainer = UIView()
        addSubview(gradeContainer)
        gradeContainer.anchor
            .height(constant: gradeContainerDiameter)
            .width(to: gradeContainer.heightAnchor)
            .bottom(to: bottomAnchor, constant: -4)
            .centerX(to: centerXAnchor)
            .activate()
        gradeContainer.backgroundColor = .systemGray5
        gradeContainer.layer.cornerRadius = gradeContainerDiameter / 2

        gradeContainer.addSubview(gradeLabel)
        gradeLabel.anchor
            .centerX(to: gradeContainer.centerXAnchor)
            .centerY(to: gradeContainer.centerYAnchor)
            .activate()
        
        nameLabelContainer.anchor
            .top(to: topAnchor, constant: 20)
            .leading(to: leadingAnchor)
            .trailing(to: trailingAnchor)
            .bottom(to: gradeContainer.topAnchor, constant: -20)
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
        
        let path = UIBezierPath()

        // create the path
        path.move(to: topLeftCorner)
        path.addLine(to: topRightCorner)
        path.addLine(to: bottomRightCorner)
        path.addLine(to: bottomCenter)
        path.addLine(to: bottomLeftCorner)
        path.close()
        
        fill(path)
    }
    
    public func configureWith(term: Term) {
        self.term = term
        termNameLabel.text = term.name
        gradeLabel.text = "\(Int(term.grade.rounded()))"
        setNeedsDisplay()
    }
    
    private func fill(_ path: UIBezierPath) {
        let fillColor = UIColor.getColor(for: term)
        fillColor.set()
        path.fill()
    }
    
}
