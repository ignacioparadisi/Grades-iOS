//
//  TermDetailViewController2.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermDetailViewController: BaseViewController {
    
    enum TableSections: Int {
        case dateSection = 0
        case chartSection = 1
        case subjectsSection = 2
    }
    
    var tableView: UITableView!
    var term: Term = Term()
    var subjects: [Subject] = []
    weak var delegate: CreateTermViewControllerDelegate?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = term.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateSubject))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(goToEditTerm))
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: false)
    }
    
    @objc func goBack() {
        dismiss(animated: true)
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
        tableView.register(TermDateTableViewCell.self)
        tableView.register(TitleLabelTableViewCell.self)
        tableView.register(GradableTableViewCell.self)
        tableView.register(BarChartTableViewCell.self)
        
        fetchSubjects()
    }
    
    @objc private func goToCreateSubject() {
        let viewController = CreateSubjectViewController()
        viewController.delegate = self
        viewController.term = term
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    @objc private func goToEditTerm() {
        let viewController = EditTermViewController()
        viewController.delegate = self
        viewController.term = term
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func fetchSubjects() {
        subjects = AbstractServiceFactory.getServiceFactory(for: .realm).subjectService.fetchSubjects(for: term)
        term.subjects = subjects
        tableView.reloadData()
    }
    
}

extension TermDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSections(rawValue: section) {
        case .dateSection?:
            return 1
        case .chartSection?:
            return (subjects.isEmpty) ? 0 : 2
        case .subjectsSection?:
            return (subjects.isEmpty) ? 0 : subjects.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch TableSections(rawValue: section) {
        case .dateSection?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TermDateTableViewCell
            cell.configure(startDate: term.startDate, endDate: term.endDate)
            return cell
        case .chartSection?:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
                cell.titleLabel.text = "Stats".localized
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
                cell.configure(with: subjects)
                return cell
            }
        default:
            if row == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
                cell.titleLabel.text = "Subjects".localized
                return cell
            } else {
                let index = row - 1
                let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
                cell.configure(with: subjects[index])
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == TableSections.subjectsSection.rawValue && row > 0 {
            let index = row - 1
            let subject = subjects[index]
            let viewController = SubjectDetailViewController()
            viewController.delegate = self
            viewController.subject = subject
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = DetailHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))
            header.configure(with: term)
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
        return indexPath.section == TableSections.subjectsSection.rawValue && indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row -  1
        if editingStyle == .delete {
            subjects.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadRows(at: [IndexPath(row: 1, section: TableSections.chartSection.rawValue)], with: .none)
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
}

