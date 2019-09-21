//
//  ScrollableView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

/// Adds a UIScrollView as a subview
protocol ScrollableView: class {
    var contentView: UIView { get set }
    func addScrollView()
}

extension ScrollableView where Self: UIViewController {
    
    /// Adds a UIScrollView as a subview
    func addScrollView() {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        
        scrollView.anchor
            .edgesToSuperview()
            .activate()
        
        contentView = UIView()
        contentView.backgroundColor = .systemBackground
        
        scrollView.addSubview(contentView)
        contentView.anchor
            .edgesToSuperview()
            .width(to: scrollView.widthAnchor)
            // .height(to: scrollView.heightAnchor, priority: .defaultLow)
            .activate()
        
    }
    
}
