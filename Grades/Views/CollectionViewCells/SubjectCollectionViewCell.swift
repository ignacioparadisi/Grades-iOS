//
//  SubjectCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectCollectionViewCell: UICollectionViewCell, ReusableView {
    
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
            .trailing(to: trailingAnchor)
            .bottom(to: bottomAnchor)
            .leading(to: leadingAnchor, constant: 16)
            .height(constant: 1)
            .activate()
    }
    
}
