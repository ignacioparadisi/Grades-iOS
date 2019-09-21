//
//  GradesViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwiftUI


final class TermsViewController: BaseViewController, UIViewControllerRepresentable {
    /// Collection View containing Terms
    var collectionView: UICollectionView!
    /// Terms to be displayed
    private var terms: [Term] = []
    /// Current selected cell
    var selectedCell: Int = -1
    
    /// Sets up Navigation Bar buttons and title
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms".localized
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateTerm))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchTerms))
        navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: false)
    }
    
    /// Sets up elements in the view
    override func setupView() {
        super.setupView()
        setupCollectionView()
        fetchTerms()
    }
    
    /// Creates a new Collection View and registers its cells
    func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 80
        layout.sectionInset = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        
        view.addSubview(collectionView)
        collectionView.anchor.edgesToSuperview(toSafeArea: true).activate()
        collectionView.register(TermCollectionViewCell.self)
    }
    
    /// Fetches Terms from Database
    @objc private func fetchTerms() {
        do {
            self.terms = try Term.fetchAll()
        } catch {
            print("Error fetching terms")
        }
        collectionView.reloadData()
        if !terms.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let indexPath = IndexPath(item: self.terms.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    /// Presents the View Controller to create a new Term
    @objc private func goToCreateTerm() {
        let viewController =  CreateTermViewController()
        viewController.delegate = self
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - Required UIViewControllerRepresentable functions

extension TermsViewController {
    typealias UIViewControllerType = TermsViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TermsViewController>) -> TermsViewController {
        return TermsViewController()
    }
    
    func updateUIViewController(_ uiViewController: TermsViewController, context: UIViewControllerRepresentableContext<TermsViewController>) {}
}


// MARK: - UICollectionView Data Source, Delegate and Delegate Flow Layout
extension TermsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return terms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(for: indexPath) as TermCollectionViewCell
        cell.delegate = self
        cell.tag = item
        cell.term = terms[item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 80, height: collectionView.frame.height - 40)
    }
    
}

extension TermsViewController: CreateTermViewControllerDelegate {
    /// Fetches the Terms
    func shouldRefresh() {
        fetchTerms()
    }
    
}

extension TermsViewController: TermCollectionViewCellDelegate {
    
    /// Show an alert to confirm the deletion of a Term
    /// - Parameter item: Index of the term to be deleted
    func showDeleteAlert(index: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
            self?.deleteTerm(at: index)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    /// Deletes a Term with animation from the CollectionVIew
    /// - Parameter index: Index of the Term to be deleted
    private func deleteTerm(at index: Int) {
        let term = terms[index]
        terms.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        term.delete()
        fetchTerms()
    }
    
    /// Pushes the View Controller to Term Detail into the Navigation Stack
    /// - Parameter item: Index of the term to shown
    func goToTermDetail(index: Int) {
        selectedCell = index
        let term = terms[index]
        let viewController = TermDetailViewController()
        viewController.delegate = self
        viewController.term = term
        navigationController?.pushViewController(viewController, animated: true)
    }
}
