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
        
        print(UIScreen.main.bounds.width)
        scrollView.anchor
            .edgesToSuperview(toSafeArea: true)
            .width(constant: UIScreen.main.bounds.width)
            .activate()
        
        contentView = UIView()
        contentView.backgroundColor = .clear
        
        scrollView.addSubview(contentView)
        contentView.anchor
            .edgesToSuperview()
            .width(to: scrollView.widthAnchor)
            .height(to: scrollView.heightAnchor, priority: .defaultLow)
            .activate()
    }
    
}
