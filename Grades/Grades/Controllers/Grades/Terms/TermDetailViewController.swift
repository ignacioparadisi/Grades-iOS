//
//  TermDetailViewController2.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/18/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import SwiftUI

enum Section: CaseIterable {
    case first
}

struct TermDetailViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = TermDetailViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TermDetailViewControllerWrapper>) -> TermDetailViewController {
        return TermDetailViewController()
    }
    
    func updateUIViewController(_ uiViewController: TermDetailViewController, context: UIViewControllerRepresentableContext<TermDetailViewControllerWrapper>) {
    }
}

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
    
    /// Setups the navigation bar buttons an title
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = term.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateSubject))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(goToEditTerm))
        navigationItem.setRightBarButtonItems([addButton, editButton], animated: false)
    }
    
    /// Goes to the previous View Controller
    @objc func goBack() {
        dismiss(animated: true)
    }
    
    /// Setups the view
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
        delegate?.shouldRefresh()
    }
}

extension TermDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subjects.isEmpty {
            return 1
        }
        return subjects.count + TableRows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        switch TableRows(rawValue: row) {
        case .dateRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TermDateTableViewCell
            cell.configure(startDate: term.startDate, endDate: term.endDate)
            return cell
        case .chartTitleRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
            cell.titleLabel.text = "Stats".localized
            return cell
        case .chartRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
            cell.configure(with: subjects)
            return cell
        case .subjectsTitleRow?:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TitleLabelTableViewCell
            cell.titleLabel.text = "Subjects".localized
            return cell
        default:
            let index = row - TableRows.allCases.count
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
            cell.configure(with: subjects[index])
            return cell
        }
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
}

