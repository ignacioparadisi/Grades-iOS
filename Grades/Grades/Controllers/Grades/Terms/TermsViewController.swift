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
    typealias UIViewControllerType = TermsViewController
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<TermsViewController>) -> TermsViewController {
        return TermsViewController()
    }
    
    func updateUIViewController(_ uiViewController: TermsViewController, context: UIViewControllerRepresentableContext<TermsViewController>) {
    }
    
    var collectionView: UICollectionView!
    private var terms: [Term] = []
//    let transition = PopAnimator()
    var selectedCell: Int = -1
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms".localized
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateTerm))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchTerms))
        // let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(goToEditTerms))
        navigationItem.setRightBarButtonItems([refreshButton, addButton], animated: false)
    }
    
    override func setupView() {
        super.setupView()
        setupCollectionView()
        fetchTerms()
    }
    
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
    
    @objc private func fetchTerms() {
        let service = AbstractServiceFactory.getServiceFactory(for: .realm)
        service.termService.fetchTerms() { result in
            switch result {
            case .success(let terms):
                self.terms = terms
            case.failure:
                print("Failed fetching terms")
                break
            }
        }
        terms = terms.sorted(by: { (term1, term2) -> Bool in
            return term1.position < term2.position
        })
        collectionView.reloadData()
        if !terms.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let indexPath = IndexPath(item: self.terms.count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    @objc private func goToCreateTerm() {
        let viewController = CreateTermViewController()
        viewController.delegate = self
        viewController.termsCount = terms.count
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    @objc private func goToEditTerms() {
        let viewController = EditTermsViewController()
        viewController.delegate = self
        viewController.terms = terms
        present(UINavigationController(rootViewController: viewController), animated: true)
    }

}

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
    
    func shouldRefresh() {
        fetchTerms()
    }
    
}

extension TermsViewController: TermCollectionViewCellDelegate {
    
    func showDeleteAlert(item: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete".localized, style: .destructive) { [weak self] _ in
            self?.deleteTerm(at: item)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func deleteTerm(at index: Int) {
        let term = terms[index]
        terms.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
        let service = AbstractServiceFactory.getServiceFactory(for: .realm)
        service.termService.deleteTerm(term) { result in
            switch result {
            case .success:
                print("Successfully deleted term")
            case .failure:
                print("Failed deleting term")
            }
        }
        
        // fetchTerms()
    }
    
    func goToTermDetail(item: Int) {
        selectedCell = item
        let term = terms[item]
        let viewController = TermDetailViewController()
        viewController.delegate = self
        viewController.term = term
//        navigationController?.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension TermsViewController: EditTermsViewControllerDelegate {
    
    func didEditTerms() {
        fetchTerms()
    }
    
}

// TODO: Make the transition animation
//extension GradesViewController: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        guard
//            let selectedCell = collectionView.cellForItem(at: IndexPath(item: selectedCell, section: 0))
//                as? TermCollectionViewCell,
//            let selectedCellSuperview = selectedCell.superview
//            else {
//                return nil
//        }
//
//        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
//        transition.originFrame = CGRect(
//            x: transition.originFrame.origin.x,
//            y: transition.originFrame.origin.y - 50,
//            width: transition.originFrame.size.width,
//            height: transition.originFrame.size.height + 50
//        )
//
//        transition.presenting = true
//        return transition
//    }
//}
