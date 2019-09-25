//
//  CalendarDayCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/24/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarDayCell: JTACDayCell {
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let currentDateView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.accentColor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let roundedPath = UIBezierPath(roundedRect: currentDateView.bounds, cornerRadius: currentDateView.bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        currentDateView.layer.mask = maskLayer
    }
    
    private func initialize() {
        addSubview(currentDateView)
        addSubview(dateLabel)
        
        currentDateView.anchor
            .centerToSuperview()
            .leadingToSuperview()
            .trailingToSuperview()
            .height(to: currentDateView.widthAnchor)
            .activate()
        
        dateLabel.anchor
            .leadingToSuperview()
            .trailingToSuperview()
            .centerYToSuperview()
            .activate()
    }
}
