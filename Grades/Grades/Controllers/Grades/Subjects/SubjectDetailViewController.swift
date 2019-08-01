//
//  SubjectDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectDetailViewController: BaseViewController {
    
    enum TableSections: Int {
        case chartSection = 0
        case assignmentsSection = 1
    }

    var tableView: UITableView!
    var subject: Subject = Subject()
    var assignments: [Assignment] = []
    weak var delegate: CreateSubjectViewControllerDelegate?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = subject.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateAssignment))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: false)
    }
    
    override func setupView() {
        super.setupView()
        
        tableView = UITableView(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        view.addSubview(tableView)
        tableView.anchor
            .edgesToSuperview(toSafeArea: true)
            .activate()
        tableView.register(TitleLabelTableViewCell.self)
        tableView.register(AssignmentTableViewCell.self)
        tableView.register(BarChartTableViewCell.self)
        
        fetchAssignments()
    }
    
    @objc private func goToCreateAssignment() {
        let controller = CreateAssignmentViewController()
        controller.subject = subject
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true)
    }
    
    private func fetchAssignments() {
        assignments = AbstractServiceFactory.getServiceFactory(for: .realm).assignmentService.fetchAssignments(for: subject)
        tableView.reloadData()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet, blurStyle: .dark)
        let editDateAction = UIAlertAction(title: "Edit date".localized, style: .default, handler: nil)
        let editGradeAction = UIAlertAction(title: "Edit grade".localized, style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        actionSheet.addAction(editDateAction)
        actionSheet.addAction(editGradeAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }

}

extension SubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSections(rawValue: section) {
        case .chartSection?:
            return (assignments.isEmpty) ? 0 : 2
        case .assignmentsSection?:
            return (assignments.isEmpty) ? 0 : assignments.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch TableSections(rawValue: section) {
        case .chartSection?:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
                cell.titleLabel.text = "Stats".localized
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
                cell.configure(with: assignments)
                return cell
            }
        default:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
                cell.titleLabel.text = "Assignments".localized
                return cell
            } else {
                let index = row - 1
                let cell = tableView.dequeueReusableCell(for: indexPath) as AssignmentTableViewCell
                cell.configure(with: assignments[index])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == TableSections.assignmentsSection.rawValue && row > 0 {
            showActionSheet()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = DetailHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
            header.configure(with: subject)
            return header
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 120
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == TableSections.assignmentsSection.rawValue && indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row -  1
        if editingStyle == .delete {
            assignments.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadRows(at: [IndexPath(row: 1, section: TableSections.chartSection.rawValue)], with: .none)
        }
    }
}

extension SubjectDetailViewController: CreateAssignmentViewControllerDelegate {
    
    func didCreateAssignment() {
        fetchAssignments()
        delegate?.shouldRefresh()
    }
    
}
