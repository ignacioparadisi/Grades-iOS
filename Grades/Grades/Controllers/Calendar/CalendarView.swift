//
//  CalendarView.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/24/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarView: UIView {

    var reuseIdentifier = "dateCell"
    var calendar: JTACMonthView!
    var daysOfWeek: [String] = ["S", "M", "T", "W", "T", "F", "S"]
    let daysOfWeekStackView = UIStackView()
    let monthLabel = UILabel()
    var calendarDataSource: [String: [Assignment]] = [:]
    var dateFormatter: DateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let monthView = UIView()
        monthView.addSubview(monthLabel)
        monthLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        
        let todayButton = UIButton()
        let today = Date()
        dateFormatter.dateFormat = "MMM d, yyyy"
        todayButton.setTitle(dateFormatter.string(from: today), for: .normal)
        todayButton.setTitleColor(UIColor.accentColor, for: .normal)
        todayButton.addTarget(self, action: #selector(goToToday), for: .touchUpInside)
        monthView.addSubview(todayButton)
        
        monthLabel.anchor
            .topToSuperview(constant: 16)
            .leadingToSuperview(constant: 20)
            .trailing(lesserOrEqual: monthView.centerXAnchor, constant: -8)
            .bottomToSuperview(constant: -16)
            .activate()
        
        todayButton.anchor
            .trailingToSuperview(constant: -20)
            .centerYToSuperview()
            .activate()
        
        daysOfWeekStackView.alignment = .center
        daysOfWeekStackView.axis = .horizontal
        daysOfWeekStackView.distribution = .fillEqually
        for day in daysOfWeek {
            let label = UILabel()
            label.textAlignment = .center
            label.text = day
            label.textColor = .secondaryLabel
            daysOfWeekStackView.addArrangedSubview(label)
        }
        
        addSubview(monthView)
        addSubview(daysOfWeekStackView)
        
        monthView.anchor.topToSuperview().leadingToSuperview().trailingToSuperview().activate()
        daysOfWeekStackView.anchor
            .top(to: monthView.bottomAnchor)
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
        
        backgroundColor = .clear
        setupCalendarView()
        
        DispatchQueue.main.async { [weak self] in
            self?.populateCalendarDataSource()
        }
        
    }
    
    func updateUI() {
        populateCalendarDataSource()
    }
    
    private func populateCalendarDataSource() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        calendarDataSource.removeAll()
        var assignments: [Assignment] = []
        do {
            assignments = try Assignment.fetchForCalendar()
        } catch {
            print(error)
            Logger.log("Error fetching assignments for calendar", category: .assignment, type: .error)
        }
        for assignment in assignments {
            let key = dateFormatter.string(from: assignment.deadline)
            if calendarDataSource[key] == nil {
                calendarDataSource[key] = [assignment]
            } else {
                calendarDataSource[key]?.append(assignment)
            }
        }
        calendar.reloadData()
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
        calendar.scrollToDate(getSunday(from: Date()), animateScroll: false)
        addSubview(calendar)
        calendar.anchor
            .top(to: daysOfWeekStackView.bottomAnchor)
            .trailingToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .height(to: calendar.widthAnchor, multiplier: 1)
            .activate()
    }
    
    private func getSunday(from date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        let sunday = calendar.date(from: components)!
        return sunday
    }
    
    @objc private func goToToday() {
        calendar.scrollToDate(getSunday(from: Date()), animateScroll: true)
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
    
    private func configureCell(_ cell: JTACDayCell, cellState: CellState) {
        guard let cell = cell as? CalendarDayCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellEvents(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        DispatchQueue.main.async { [weak self] in
            guard let date = visibleDates.monthDates.first?.date else { return }
            self?.dateFormatter.dateFormat = "MMMM yyyy"
            self?.monthLabel.text = self?.dateFormatter.string(from: date)
        }
    }
    
    private func handleCellTextColor(cell: CalendarDayCell, cellState: CellState) {
       if cellState.dateBelongsTo == .thisMonth {
        cell.dateLabel.textColor = .label
       } else {
        cell.dateLabel.textColor = .secondaryLabel
       }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: cellState.date)
        let date = Calendar.current.date(from: dateComponents)
        let todayComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let today = Calendar.current.date(from: todayComponents)
        
        if date == today {
            cell.configureToday()
        } else {
            cell.configureAllButToday()
        }
    }
    
    func handleCellEvents(cell: CalendarDayCell, cellState: CellState) {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: cellState.date)
        if calendarDataSource[dateString] == nil {
            cell.notificationView.isHidden = true
        } else {
            cell.notificationView.isHidden = false
        }
    }
    
}
