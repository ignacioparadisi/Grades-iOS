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
    /// Current selected cell
    var selectedCell: Int = -1
    
    /// Sets up Navigation Bar buttons and title
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms".localized
        setupAddAndOptionsButton()
    }
    
    /// Sets up elements in the view
    override func setupView() {
        super.setupView()
        setupTableView()
        fetchTerms()
    }
    
    /// Creates a new Collection View and registers its cells
    func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.register(TermGradeTableViewCell.self)
        // collectionView.register(TermCollectionViewCell.self)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
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
        } else {
            let cell = UITableViewCell()
            cell.textLabel?.text = terms[indexPath.row].name
            return cell
        }
    }
    
}

extension TermsViewController: CreateTermViewControllerDelegate {
    /// Fetches the Terms
    func shouldRefresh() {
        fetchTerms()
    }
    
}

//extension TermsViewController: TermCollectionViewCellDelegate {
//    
//    /// Show an alert to confirm the deletion of a Term
//    /// - Parameter item: Index of the term to be deleted
//    func showDeleteAlert(index: Int) {
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
//            self?.deleteTerm(at: index)
//        }
//        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
//        
//        alertController.addAction(deleteAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true)
//    }
//    
//    /// Deletes a Term with animation from the CollectionVIew
//    /// - Parameter index: Index of the Term to be deleted
//    private func deleteTerm(at index: Int) {
//        let term = terms[index]
//        terms.remove(at: index)
//        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
//        term.delete()
//        fetchTerms()
//    }
//    
//    /// Pushes the View Controller to Term Detail into the Navigation Stack
//    /// - Parameter item: Index of the term to shown
//    func goToTermDetail(index: Int) {
//        selectedCell = index
//        let term = terms[index]
//        let viewController = TermDetailViewController()
//        viewController.delegate = self
//        viewController.term = term
//        navigationController?.pushViewController(viewController, animated: true)
//    }
//}
