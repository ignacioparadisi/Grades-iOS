//
//  CalendarViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController, ScrollableView {

    var contentView: UIView = UIView()
    let calendarView: CalendarView = CalendarView()
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Calendar".localized
    }
    
    override func setupView() {
        super.setupView()
        addScrollView()
        contentView.addSubview(calendarView)
        calendarView.layer.cornerRadius = 10
        calendarView.backgroundColor = .systemGray5
        calendarView.anchor
            .topToSuperview(constant: 20, toSafeArea: true)
            .leadingToSuperview(constant: 16)
            .trailingToSuperview(constant: -16)
            .bottomToSuperview()
            .activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.updateUI()
    }

}
