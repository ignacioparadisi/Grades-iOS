//
//  GradesViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI


final class TermsViewController: BaseViewController {
    /// Collection View containing Terms
    var tableView: UITableView!
    /// Terms to be displayed
    private var terms: [Term] = []
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showAddButton(false)
    }
    
    /// Sets up Navigation Bar buttons and title
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms".localized
        showAddButton(true)
    }
    
    /// Sets up elements in the view
    override func setupView() {
        super.setupView()
        setupAddButton()
        setupTableView()
        fetchTerms()
    }
    
    /// Creates a new Collection View and registers its cells
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(TermGradeTableViewCell.self)
        tableView.register(BarChartTableViewCell.self)
        tableView.register(GradableTableViewCell.self)
    }
    
    /// Fetches Terms from Database
    @objc private func fetchTerms() {
        do {
            self.terms = try Term.fetchAll()
        } catch {
            print("Error fetching terms")
        }
        tableView.reloadData()
    }
    
    /// Presents the View Controller to create a new Term
     override func didTapAddButton() {
        let viewController =  CreateTermViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UICollectionView Data Source, Delegate and Delegate Flow Layout
extension TermsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return terms.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as TermGradeTableViewCell
            cell.configure(with: 20)
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as BarChartTableViewCell
            cell.configure(with: terms)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
            cell.configure(with: terms[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            deleteTerm(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            goToTermDetail(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 2 {
            return "Terms".localized
        }
        return nil
    }
    
    /// Deletes a Term with animation from the CollectionVIew
    /// - Parameter index: Index of the Term to be deleted
    private func deleteTerm(at index: Int) {
        let term = terms[index]
        terms.remove(at: index)
        tableView.deleteRows(at: [IndexPath(item: index, section: 2)], with: .left)
        tableView.reloadSections(IndexSet(arrayLiteral: 0, 1), with: .automatic)
        term.delete()
        fetchTerms()
    }

    /// Pushes the View Controller to Term Detail into the Navigation Stack
    /// - Parameter item: Index of the term to shown
    func goToTermDetail(index: Int) {
        let term = terms[index]
        let viewController = TermDetailViewController()
        viewController.delegate = self
        viewController.term = term
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TermsViewController: CreateTermViewControllerDelegate {
    /// Fetches the Terms
    func shouldRefresh() {
        fetchTerms()
    }
    
}
