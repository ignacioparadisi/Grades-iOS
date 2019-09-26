//
//  CalendarTableViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 9/25/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CalendarViewController: BaseViewController {
    
    private enum TableSection: Int {
        case calendar = 0
        case events = 1
    }

    let tableView: UITableView = UITableView()
    var assignments: [Assignment]?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Calendar".localized
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.register(CalendarTableViewCell.self)
        tableView.register(EventTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .calendar?:
            return 1
        default:
            return assignments?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TableSection(rawValue: indexPath.section) {
        case .calendar?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CalendarTableViewCell
            cell.delegate = self
            return cell
        default:
            guard let assignment = assignments?[indexPath.row] else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(for: indexPath) as EventTableViewCell
            cell.configure(with: assignment)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TableSection(rawValue: section) {
        case .events?:
            let view = UIView()
            let label = IPTitleLabel()
            label.text = "Events".localized
            
            view.addSubview(label)
            label.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)).activate()
            return view
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TableSection(rawValue: section) {
        case .events?:
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TableSection(rawValue: indexPath.section) {
        case .calendar?:
            return view.frame.width + 100
        default:
            return UITableView.automaticDimension
        }
    }
}

extension CalendarViewController: CalendarTableViewCellDelegate {
    func didSelectDate(_ assignments: [Assignment]?) {
        var animation: UITableView.RowAnimation = .none
        if let assignments = assignments, !assignments.isEmpty, assignments != self.assignments {
            animation = .fade
        }
        self.assignments = assignments
        tableView.reloadSections(IndexSet(integer: TableSection.events.rawValue), with: animation)
    }
}
