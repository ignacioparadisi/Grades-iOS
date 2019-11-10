//
//  SubjectDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectDetailViewController: BaseViewController {
    
    struct Sections {
        static let grades = 0
        static let chart = 1
        static let assignments = 2
        
        static let count = 3
    }

    var tableView: UITableView!
    var subject: Subject = Subject()
    var assignments: [Assignment] = []
    weak var delegate: CreateSubjectViewControllerDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBarButtons(false)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = subject.name
        showNavigationBarButtons(true)
    }
    
    override func setupView() {
        super.setupView()
        setupAddAndOptionsButton()
        setupTableView()
        fetchAssignments()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        view.addSubview(tableView)
        tableView.anchor
            .edgesToSuperview()
            .activate()
        tableView.register(GradeTableViewCell.self)
        tableView.register(AssignmentTableViewCell.self)
        tableView.register(BarChartTableViewCell.self)
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
    
    private func deleteAssignment(at indexPath: IndexPath) {
        let index = indexPath.row
        let assignment = assignments[index]
        assignments.remove(at: index)
        if !assignments.isEmpty {
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadSections(IndexSet(arrayLiteral: Sections.grades, Sections.chart), with: .automatic)
        } else {
            tableView.deleteSections(IndexSet(arrayLiteral: Sections.chart, Sections.assignments), with: .fade)
        }
        assignment.delete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tableView.reloadData()
        }
        delegate?.shouldRefresh()
    }
    
    override func didTapAddButton() {
        goToCreateAssignment()
    }

}

extension SubjectDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return assignments.isEmpty ? Sections.count - 2 : Sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.grades:
            return 1
        case Sections.chart:
            return assignments.isEmpty ? 0 : 1
        case Sections.assignments:
            return assignments.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case Sections.grades:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradeTableViewCell
            cell.configure(with: subject)
            return cell
        case Sections.chart:
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
            cell.configure(with: assignments)
            return cell
        case Sections.assignments:
            let cell = tableView.dequeueReusableCell(for: indexPath) as AssignmentTableViewCell
            cell.configure(with: assignments[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == Sections.assignments {
            goToAssignmentDetail(assignments[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Sections.assignments
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteAssignment(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == Sections.assignments ? "Assignments" : nil
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
