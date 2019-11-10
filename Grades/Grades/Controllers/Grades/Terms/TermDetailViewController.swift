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
    struct Sections {
        static let grades = 0
        static let dates = 1
        static let chart = 2
        static let subjects = 3
        
        static let count = 4
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
        tableView.register(BarChartTableViewCell.self)
        tableView.register(GradableTableViewCell.self)
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
        let subject: Subject = subjects[indexPath.row]
        subjects.remove(at: indexPath.row)
        if !subjects.isEmpty {
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadSections(IndexSet(arrayLiteral: Sections.grades, Sections.chart), with: .automatic)
        } else {
            tableView.deleteSections(IndexSet(arrayLiteral: Sections.chart, Sections.subjects), with: .fade)
        }
        subject.delete()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.tableView.reloadData()
        }
        delegate?.shouldRefresh()
    }
    
    override func didTapAddButton() {
        goToCreateSubject()
    }
}

extension TermDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return subjects.isEmpty ? Sections.count - 2 : Sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Sections.grades:
            return 1
        case Sections.dates:
            return 1
        case Sections.chart:
            return subjects.isEmpty ? 0 : 1
        case Sections.subjects:
            return subjects.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case Sections.grades:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradeTableViewCell
            cell.configure(with: term)
            return cell
        case Sections.dates:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TermDateTableViewCell
            cell.configure(startDate: term.startDate, endDate: term.endDate)
            return cell
        case Sections.chart:
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
           cell.configure(with: subjects)
           return cell
        case Sections.subjects:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
            cell.configure(with: subjects[indexPath.row])
            return cell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section >= Sections.subjects {
            let subject = subjects[indexPath.row]
            let viewController = SubjectDetailViewController()
            viewController.delegate = self
            viewController.subject = subject
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == Sections.subjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSubject(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Sections.subjects {
            return "Subjects".localized
        }
        return nil
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

