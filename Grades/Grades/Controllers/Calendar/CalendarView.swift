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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        let monthView = UIView()
        let monthLabel = UILabel()
        monthView.addSubview(monthLabel)
        monthLabel.anchor.edgesToSuperview(toSafeArea: true).activate()
        
        addSubview(monthView)
        monthView.anchor.topToSuperview().leadingToSuperview().trailingToSuperview().activate()
        
        backgroundColor = .systemBackground
        calendar = JTACMonthView(frame: .zero)
        calendar.register(CalendarDayCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        calendar.minimumInteritemSpacing = 0
        calendar.minimumLineSpacing = 0
        calendar.ibCalendarDelegate = self
        calendar.ibCalendarDataSource = self
        calendar.backgroundColor = .systemBackground
        calendar.isPagingEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.showsHorizontalScrollIndicator = false
        calendar.scrollToDate(getSunday(from: Date()), animateScroll: false)
        addSubview(calendar)
        calendar.anchor.edgesToSuperview().activate()
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
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
            cell.currentDateView.isHidden = false
            cell.dateLabel.textColor = .systemBackground
        } else {
            cell.currentDateView.isHidden = true
        }
        
    }
    
}
