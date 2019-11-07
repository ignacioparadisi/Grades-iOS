//
//  TermDetailViewController2.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

class TermDetailViewController: BaseViewController {
    /// Type of rows inside the Table View
    enum TableRows: Int, CaseIterable {
        case dateRow = 0
        case chartTitleRow = 1
        case chartRow = 2
        case subjectsTitleRow = 3
    }
    
    /// Tabla View to display Subjects
    var tableView: UITableView!
    /// Term to be displayed
    var term: Term = Term()
    /// Subjects of the selected Term
    var subjects: [Subject] = []
    weak var delegate: CreateTermViewControllerDelegate?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBarButtons(false)
    }
    
    /// Setups the navigation bar buttons an title
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = term.name
        showNavigationBarButtons(true)
    }
    
    /// Goes to the previous View Controller
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    /// Setups the view
    override func setupView() {
        super.setupView()
        setupAddAndOptionsButton()
        setupTableView()
        fetchSubjects()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        view.addSubview(tableView)
        tableView.anchor
            .edgesToSuperview()
            .activate()
        tableView.register(GradeTableViewCell.self)
        tableView.register(TermDateTableViewCell.self)
        tableView.register(TitleLabelTableViewCell.self)
        tableView.register(GradableTableViewCell.self)
        tableView.register(BarChartTableViewCell.self)
    }
    
    /// Presents the View Controller to create a new Subject
    @objc private func goToCreateSubject() {
        let viewController = CreateSubjectViewController()
        viewController.delegate = self
        viewController.term = term
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    /// Presents View Controller to edit Term
    @objc private func goToEditTerm() {
        let viewController = EditTermViewController()
        viewController.delegate = self
        viewController.term = term
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    /// Gets subjects from Term
    private func fetchSubjects() {
        subjects = term.getSubjects()
        tableView.reloadData()
    }
    
    /// Deletes a subject from Table View with animation and then deletes it from Core Data
    private func deleteSubject(at indexPath: IndexPath) {
        let index = indexPath.row -  TableRows.allCases.count
        let subject: Subject = subjects[index]
        subjects.remove(at: index)
        if !subjects.isEmpty {
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadRows(at: [IndexPath(row: TableRows.chartRow.rawValue, section: 0)], with: .none)
        } else {
            let indexPaths = [
                indexPath,
                IndexPath(row: TableRows.chartTitleRow.rawValue, section: 0),
                IndexPath(row: TableRows.chartRow.rawValue, section: 0),
                IndexPath(row: TableRows.subjectsTitleRow.rawValue, section: 0)
            ]
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        subject.delete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tableView.reloadData()
        }
        delegate?.shouldRefresh()
    }
}

extension TermDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else {
            return subjects.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradeTableViewCell
            cell.configure(with: term)
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TermDateTableViewCell
            cell.configure(startDate: term.startDate, endDate: term.endDate)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
            cell.configure(with: subjects[indexPath.row])
            return cell
        }
        
//        switch TableRows(rawValue: row) {
//        case .dateRow?:
//            let cell = tableView.dequeueReusableCell(for: indexPath) as TermDateTableViewCell
//            cell.configure(startDate: term.startDate, endDate: term.endDate)
//            return cell
//        case .chartTitleRow?:
//            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
//            cell.titleLabel.text = "Stats".localized
//            return cell
//        case .chartRow?:
//            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
//            cell.configure(with: subjects)
//            return cell
//        case .subjectsTitleRow?:
//            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
//            cell.titleLabel.text = "Subjects".localized
//            return cell
//        default:
//            let index = row - TableRows.allCases.count
//            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
//            cell.configure(with: subjects[index])
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row >= TableRows.allCases.count {
            let index = row - TableRows.allCases.count
            let subject = subjects[index]
            let viewController = SubjectDetailViewController()
            viewController.delegate = self
            viewController.subject = subject
            navigationController?.pushViewController(viewController, animated: true)
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
            deleteSubject(at: indexPath)
        }
    }
}

extension TermDetailViewController: CreateSubjectViewControllerDelegate, CreateTermViewControllerDelegate {
    func shouldRefresh() {
        fetchSubjects()
        delegate?.shouldRefresh()
    }
}

extension TermDetailViewController: EditTermViewControllerDelegate {
    func didEditTerm(_ term: Term) {
        self.term = term
        tableView.reloadData()
        delegate?.shouldRefresh()
    }
    
    func didDeleteTerm() {
        delegate?.shouldRefresh()
        navigationController?.popViewController(animated: true)
    }
}

