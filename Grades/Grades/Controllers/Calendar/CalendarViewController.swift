//
//  CalendarViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

class CalendarViewController: BaseViewController, ScrollableView {

    var contentView: UIView = UIView()
    let calendarView: CalendarView = CalendarView()
    let eventsStackView: UIStackView = UIStackView()
    var selectedAssignments: [Assignment]?
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Calendar".localized
    }
    
    override func setupView() {
        super.setupView()
        addScrollView()
        setupCalendarView()
        setupEvents()
    }
    
    private func setupCalendarView() {
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 10
        calendarView.backgroundColor = .systemGray5
        contentView.addSubview(calendarView)
        calendarView.anchor
            .topToSuperview(constant: 20, toSafeArea: true)
            .leadingToSuperview(constant: 16)
            .trailingToSuperview(constant: -16)
            .activate()
    }
    
    func setupEvents() {
        let eventsLabel: IPTitleLabel = IPTitleLabel()
        eventsLabel.text = "Events".localized
        contentView.addSubview(eventsLabel)
        
        eventsLabel.anchor
            .top(to: calendarView.bottomAnchor, constant: 20)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .activate()
        
        eventsStackView.distribution = .fillEqually
        eventsStackView.alignment = .center
        eventsStackView.axis = .vertical
        eventsStackView.spacing = 16
        contentView.addSubview(eventsStackView)
        eventsStackView.anchor
            .top(to: eventsLabel.bottomAnchor, constant: 16)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .bottomToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.updateUI()
        didSelectDate(selectedAssignments)
    }

}

extension CalendarViewController: CalendarViewDelegate {
    func didSelectDate(_ assignments: [Assignment]?) {
        selectedAssignments = assignments
        removeArrangedSubviews()
        if let assignments = assignments {
            for assignment in assignments {
                let eventView = EventView(assignment: assignment)
                eventView.anchor.width(constant: eventsStackView.frame.width).activate()
                eventsStackView.addArrangedSubview(eventView)
            }
        }
    }
    
    private func removeArrangedSubviews() {
        let subviews = eventsStackView.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            eventsStackView.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(subviews.flatMap({ $0.constraints }))
        
        subviews.forEach({ $0.removeFromSuperview() })
    }
}
