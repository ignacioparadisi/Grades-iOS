//
//  TermDetailCollectionViewHeader.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol TermDetailCollectionViewHeaderDelegate: class {
    func dismissView()
}

class TermDetailCollectionViewHeader: UICollectionReusableView, ReusableView {
    
    weak var delegate: TermDetailCollectionViewHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        backgroundColor = ThemeManager.currentTheme.greenColor
        layer.cornerRadius = 10
        
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.30
        
        let button = UIButton()
        button.setTitle("x", for: .normal)
        addSubview(button)
        button.anchor
            .top(to: safeAreaLayoutGuide.topAnchor, constant: 20)
            .leading(to: safeAreaLayoutGuide.leadingAnchor, constant: 10)
            .activate()
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    @objc private func dismissView() {
        delegate?.dismissView()
    }

}
