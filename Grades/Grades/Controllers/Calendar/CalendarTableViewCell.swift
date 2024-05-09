//
//  CalendarTableViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol CalendarTableViewCellDelegate: class {
    func didSelectDate(_ assignments: [Assignment]?)
}

class CalendarTableViewCell: UITableViewCell, ReusableView {
    
    let calendarView = CalendarView()
    weak var delegate: CalendarTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        selectionStyle = .none
        addSubview(calendarView)
        calendarView.backgroundColor = .systemGray5
        calendarView.layer.cornerRadius = 10
        calendarView.delegate = self
        calendarView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 20, left: 16, bottom: -8, right: -16))
            .activate()
    }
}

extension CalendarTableViewCell: CalendarViewDelegate {
    func didSelectDate(_ assignments: [Assignment]?) {
        delegate?.didSelectDate(assignments)
    }
}
