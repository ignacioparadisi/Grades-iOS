//
//  HomeViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI

class HomeViewController: BaseViewController {
    
    enum TableSection: Int {
        case today = 0
        case thisWeek = 1
        case nextWeek = 2
    }
    
    let tableView: UITableView = UITableView()
    var todayAssignments: [Assignment] = []
    var thisWeekAssignments: [Assignment] = []
    var nextWeekAssignments: [Assignment] = []
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = "Home".localized
    }
    
    override func setupView() {
        super.setupView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EventTableViewCell.self)
        
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didCreateAssignment, object: nil)
        
        refresh()
        
    }
    
    @objc func refresh() {
        do {
            todayAssignments = try Assignment.fetchToday()
            thisWeekAssignments = try Assignment.fetchThisWeek()
            nextWeekAssignments = try Assignment.fetchNextWeek()
            tableView.reloadData()
        } catch {
            print("Error")
        }
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection(rawValue: section) {
        case .today?:
            return todayAssignments.count
        case .thisWeek?:
            return thisWeekAssignments.count
        case .nextWeek?:
            return nextWeekAssignments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as EventTableViewCell
        switch TableSection(rawValue: indexPath.section) {
        case .today?:
            cell.configure(with: todayAssignments[indexPath.row])
        case .thisWeek?:
            cell.configure(with: thisWeekAssignments[indexPath.row])
        case .nextWeek?:
            cell.configure(with: nextWeekAssignments[indexPath.row])
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = IPTitleLabel()
        view.backgroundColor = .systemBackground
        view.addSubview(label)
        label.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)).activate()
        switch TableSection(rawValue: section) {
        case .today?:
            label.text = "Today".localized
        case .thisWeek?:
            label.text = "This Week".localized
        case .nextWeek?:
            label.text = "Next Week".localized
        default:
            return nil
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat = 44
        switch TableSection(rawValue: section) {
        case .today?:
            return todayAssignments.isEmpty ? 0 : headerHeight
        case .thisWeek?:
            return thisWeekAssignments.isEmpty ? 0 : headerHeight
        case .nextWeek?:
            return nextWeekAssignments.isEmpty ? 0 : headerHeight
        default:
            return headerHeight
        }
    }
}
