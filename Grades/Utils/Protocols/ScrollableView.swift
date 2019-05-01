//
//  ScrollableView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol ScrollableView: class {
    var contentView: UIView { get set }
    func addScrollView()
}

extension ScrollableView where Self: UIViewController {
    
    func addScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        view.addSubview(scrollView)
        
        scrollView.anchor.edgesToSuperview(toSafeArea: true).activate()
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        
        scrollView.addSubview(contentView)
        contentView.anchor.edgesToSuperview().activate()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let heightContratint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        heightContratint.priority = .defaultLow
        heightContratint.isActive = true
    }
    
}
