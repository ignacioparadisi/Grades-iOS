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
        calendarView.anchor
            .topToSuperview(toSafeArea: true)
            .leadingToSuperview()
            .trailingToSuperview()
            .height(to: calendarView.widthAnchor)
            .bottomToSuperview()
            .activate()
    }

}
