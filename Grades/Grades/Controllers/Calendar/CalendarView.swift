//
//  CalendarView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/24/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol CalendarViewDelegate: class {
    func didSelectDate(_ assignments: [Assignment]?)
}

class CalendarView: UIView {

    var reuseIdentifier = "dateCell"
    var calendar: JTACMonthView!
    var daysOfWeek: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    let daysOfWeekStackView = UIStackView()
    let monthLabel = UILabel()
    var calendarDataSource: [String: [Assignment]] = [:]
    var dateFormatter: DateFormatter = DateFormatter()
    weak var delegate: CalendarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        backgroundColor = .clear
        setupMonthView()
        setupCalendarView()
        DispatchQueue.main.async { [weak self] in
            self?.populateCalendarDataSource()
            self?.scrollToCurrentDate(animated: false)
        }
        
    }
    
    private func setupMonthView() {
        let monthView = UIView()
        monthLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        let todayButton = UIButton()
        todayButton.setTitle(dateFormatter.string(from: Date(), format: .shortDate), for: .normal)
        todayButton.setTitleColor(UIColor.accentColor, for: .normal)
        todayButton.addTarget(self, action: #selector(scrollToCurrentDate), for: .touchUpInside)
        
        daysOfWeekStackView.alignment = .center
        daysOfWeekStackView.axis = .horizontal
        daysOfWeekStackView.distribution = .fillEqually
        for day in daysOfWeek {
            let label = UILabel()
            label.textAlignment = .center
            label.text = day
            label.font = UIFont.systemFont(ofSize: 12)
            if day == "S" {
                label.textColor = .secondaryLabel
            } else {
                label.textColor = .label
            }
            daysOfWeekStackView.addArrangedSubview(label)
        }
        
        addSubview(monthView)
        monthView.addSubview(monthLabel)
        monthView.addSubview(todayButton)
        addSubview(daysOfWeekStackView)
        
        monthView.anchor
            .topToSuperview()
            .leadingToSuperview()
            .trailingToSuperview().activate()
        
        monthLabel.anchor
            .topToSuperview(constant: 16)
            .leadingToSuperview(constant: 20)
            .bottomToSuperview(constant: -16)
            .activate()
        
        todayButton.anchor
            .trailingToSuperview(constant: -20)
            .centerYToSuperview()
            .activate()
        
        daysOfWeekStackView.anchor
            .top(to: monthView.bottomAnchor)
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
    }
    
    private func setupCalendarView() {
        calendar = JTACMonthView(frame: .zero)
        calendar.register(CalendarDayCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        calendar.minimumInteritemSpacing = 0
        calendar.minimumLineSpacing = 0
        calendar.ibCalendarDelegate = self
        calendar.ibCalendarDataSource = self
        calendar.backgroundColor = .clear
        calendar.isPagingEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.showsHorizontalScrollIndicator = false
        calendar.showsVerticalScrollIndicator = false
        addSubview(calendar)
        calendar.anchor
            .top(to: daysOfWeekStackView.bottomAnchor, constant: 5)
            .trailingToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .height(to: calendar.widthAnchor)
            .activate()
    }

    
    @objc private func scrollToCurrentDate(animated: Bool = true) {
        calendar.scrollToDate(getSunday(from: Date()), animateScroll: animated)
        calendar.selectDates([Date()])
    }
    
    private func populateCalendarDataSource() {
        calendarDataSource.removeAll()
        var assignments: [Assignment] = []
        do {
            assignments = try Assignment.fetchForCalendar()
        } catch {
            print(error)
            Logger.log("Error fetching assignments for calendar", category: .assignment, type: .error)
        }
        for assignment in assignments {
            let key = dateFormatter.string(from: assignment.deadline, format: .dashed)
            if calendarDataSource[key] == nil {
                calendarDataSource[key] = [assignment]
            } else {
                calendarDataSource[key]?.append(assignment)
            }
        }
        calendar.reloadData()
    }
    
    private func getSunday(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        let sunday = calendar.date(from: components)!
        return sunday
    }
}

extension CalendarView: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = Calendar.current.date(byAdding: .year, value: -10, to: Date())!
        let endDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())!
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}

extension CalendarView: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        configureCell(cell, cellState: cellState)
        return cell
    }
    
    private func configureCell(_ cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalendarDayCell  else { return }
        cell.dateLabel.text = cellState.text
         handleCellEvents(cell: cell, cellState: cellState)
         handlerCellSelection(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        DispatchQueue.main.async { [weak self] in
            guard let date = visibleDates.monthDates.first?.date else { return }
            self?.monthLabel.text = self?.dateFormatter.string(from: date, format: .monthAndYear)
        }
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, cellState: cellState)
        let key = dateFormatter.string(from: date, format: .dashed)
        delegate?.didSelectDate(calendarDataSource[key])
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, cellState: cellState)
    }
    
    func handleCellEvents(cell: CalendarDayCell, cellState: CellState) {
        let dateString = dateFormatter.string(from: cellState.date, format: .dashed)
        if calendarDataSource[dateString] == nil {
            cell.notificationView.isHidden = true
        } else {
            cell.notificationView.isHidden = false
        }
    }
    
    func handlerCellSelection(cell: CalendarDayCell, cellState: CellState) {
        if cellState.dateBelongsTo != .thisMonth {
            cell.dateLabel.textColor = .secondaryLabel
            cell.dateLabel.font = UIFont.systemFont(ofSize: 18)
            cell.currentDateView.isHidden = true
            return
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: cellState.date)
        let date = Calendar.current.date(from: dateComponents)
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar.current.date(from: todayComponents)
        
        if cellState.isSelected {
            cell.currentDateView.isHidden = false
            if date == today {
                cell.currentDateView.backgroundColor = UIColor.accentColor
                cell.dateLabel.textColor = .systemBackground
                cell.dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            } else {
                cell.currentDateView.backgroundColor = .systemGray3
                cell.dateLabel.textColor = .label
                cell.dateLabel.font = UIFont.systemFont(ofSize: 18)
            }
        } else {
            cell.currentDateView.isHidden = true
            if date == today {
                cell.dateLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                cell.dateLabel.textColor = UIColor.accentColor
            } else {
                cell.dateLabel.font = UIFont.systemFont(ofSize: 18)
                cell.dateLabel.textColor = .label
            }
        }
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if cellState.dateBelongsTo == .thisMonth {
            return true
        }
        return false
    }
    
}
