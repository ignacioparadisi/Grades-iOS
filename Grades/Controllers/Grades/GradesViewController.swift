//
//  GradesViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradesViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    private var indexOfCellBeforeDragging = 0
    private var terms: [Term] = []
//    let transition = PopAnimator()
    var selectedCell: Int = -1
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateTerm))
        navigationItem.rightBarButtonItem = addButton
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
    
    private func fetchTerms() {
        terms = ServiceFactory.createService(.realm).fetchTerms()
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
        present(UINavigationController(rootViewController: viewController), animated: true)
    }

}

extension GradesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
    
}

extension GradesViewController: CreateTermViewControllerDelegate {
    
    func shouldRefresh() {
        fetchTerms()
    }
    
}

extension GradesViewController: TermCollectionViewCellDelegate {
    
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
