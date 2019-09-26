//
//  SubjectDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectDetailViewController: BaseViewController {
    
    enum TableRows: Int, CaseIterable {
        case chartTitleRow = 0
        case chartRow = 1
        case assignmentsTitleRow = 2
    }

    var tableView: UITableView!
    let header: DetailHeader = DetailHeader(frame: .zero)
    var subject: Subject = Subject()
    var assignments: [Assignment] = []
    weak var delegate: CreateSubjectViewControllerDelegate?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = subject.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateAssignment))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(goToEditSubject))
        navigationItem.rightBarButtonItems = [addButton, editButton]
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
    
    @objc private func goToEditSubject() {
        
    }
    
    private func fetchAssignments() {
        assignments = subject.getAssignments()
        tableView.reloadData()
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editDateAction = UIAlertAction(title: "Edit deadline".localized, style: .default, handler: nil)
        let editGradeAction = UIAlertAction(title: "Edit grade".localized, style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        actionSheet.addAction(editDateAction)
        actionSheet.addAction(editGradeAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func deleteAssignment(at indexPath: IndexPath) {
        let index = indexPath.row -  TableRows.allCases.count
        let assignment = assignments[index]
        assignments.remove(at: index)
        if !assignments.isEmpty {
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadRows(at: [IndexPath(row: TableRows.chartRow.rawValue, section: 0)], with: .none)
        } else {
            let indexPaths = [
                indexPath,
                IndexPath(row: TableRows.chartTitleRow.rawValue, section: 0),
                IndexPath(row: TableRows.chartRow.rawValue, section: 0),
                IndexPath(row: TableRows.assignmentsTitleRow.rawValue, section: 0)
            ]
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        assignment.delete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tableView.reloadData()
        }
        delegate?.shouldRefresh()
    }

}

extension SubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if assignments.isEmpty {
            return 0
        }
        return assignments.count + TableRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch TableRows(rawValue: row) {
        case .chartTitleRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
            cell.titleLabel.text = "Stats".localized
            return cell
        case .chartRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
            cell.configure(with: assignments)
            return cell
        case .assignmentsTitleRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
            cell.titleLabel.text = "Assignments".localized
            return cell
        default:
            let index = row - TableRows.allCases.count
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssignmentTableViewCell
            cell.configure(with: assignments[index])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row > TableRows.assignmentsTitleRow.rawValue {
            let index = row - TableRows.allCases.count
            goToAssignmentDetail(assignments[index])
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
        return indexPath.row >= TableRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAssignment(at: indexPath)
        }
    }
    
    private func goToAssignmentDetail(_ assignment: Assignment) {
        let controller = AssignmentDetailViewController()
        controller.delegate = self
        controller.assignment = assignment
        present(UINavigationController(rootViewController: controller), animated: true)
    }
}

extension SubjectDetailViewController: CreateAssignmentViewControllerDelegate {
    
    func didCreateAssignment() {
        fetchAssignments()
        delegate?.shouldRefresh()
    }
    
}

extension SubjectDetailViewController: AssignmentDetailViewControllerDelegate {
    func didEditAssignment() {
        fetchAssignments()
        delegate?.shouldRefresh()
    }
}
