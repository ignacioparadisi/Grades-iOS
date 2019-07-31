//
//  TermDetailViewController2.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermDetailViewController: BaseViewController {
    
    enum TableRows: Int, CaseIterable {
        case dateRow = 0
        case chartRow = 1
        case subjectsRow = 2
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
        tableView.register(QualificationableTableViewCell.self)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subjects.isEmpty {
            return 1
        }
        return subjects.count + TableRows.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch TableRows(rawValue: row)  {
        case .dateRow?:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let cell = UITableViewCell()
            cell.textLabel?.textColor = ThemeManager.currentTheme.textColor
            cell.textLabel?.text = "\(dateFormatter.string(from: term.startDate)) - \(dateFormatter.string(from: term.endDate))"
            cell.textLabel?.textAlignment = .center
            cell.selectionStyle = .none
            return cell
        case .chartRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
            cell.configure(with: subjects)
            return cell
        default:
            let index = row - TableRows.allCases.count + 1
            let cell = tableView.dequeueReusableCell(for: indexPath) as QualificationableTableViewCell
            cell.configure(with: subjects[index])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row > TableRows.chartRow.rawValue {
            let index = indexPath.row - TableRows.allCases.count + 1
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
        return indexPath.row != TableRows.chartRow.rawValue
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row - TableRows.allCases.count + 1
        if editingStyle == .delete {
            subjects.remove(at: index)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadRows(at: [IndexPath(row: TableRows.chartRow.rawValue, section: 0)], with: .none)
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

