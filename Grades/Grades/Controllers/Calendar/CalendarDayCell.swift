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
        view.isHidden = true
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
        let cornerRadius = currentDateView.frame.width > currentDateView.frame.height ?
            (currentDateView.frame.height / 2) - 8 : (currentDateView.frame.width / 2) - 8
        let roundedPath = UIBezierPath(roundedRect: currentDateView.bounds, cornerRadius: cornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundedPath.cgPath
        currentDateView.layer.mask = maskLayer
    }
    
    private func initialize() {
        addSubview(currentDateView)
        addSubview(dateLabel)
        
        currentDateView.anchor
            .centerToSuperview()
            .activate()
        
        if frame.width > frame.height {
            currentDateView.anchor
                .height(to: heightAnchor, multiplier: 0.9)
                .width(to: currentDateView.heightAnchor)
                .activate()
        } else {
            currentDateView.anchor
                .width(to: widthAnchor, multiplier: 0.9)
                .height(to: currentDateView.widthAnchor)
                .activate()
        }
        
        dateLabel.anchor
            .leadingToSuperview()
            .trailingToSuperview()
            .centerYToSuperview()
            .activate()
    }
    
    func configureToday() {
        currentDateView.isHidden = false
        dateLabel.textColor = .systemBackground
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    func configureAllButToday() {
        currentDateView.isHidden = true
        dateLabel.font = UIFont.systemFont(ofSize: 20)
    }
}
