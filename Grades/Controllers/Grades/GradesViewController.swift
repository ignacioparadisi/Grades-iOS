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
    private var terms: [Term] = [
        Term(name: "Semestre 1", qualification: 0, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 2", qualification: 15, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 3", qualification: 17, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 4", qualification: 20, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 5", qualification: 6, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 6", qualification: 12, maxQualification: 20, minQualification: 10),
        Term(name: "Semestre 7", qualification: 10, maxQualification: 20, minQualification: 10)
    ]
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = "Terms"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddTerm))
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
        // terms = RealmManager.shared.getArray(ofType: Term.self) as! [Term]
        collectionView.reloadData()
    }
    
    @objc private func goToAddTerm() {
        let viewController = AddTermViewController()
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
    
}

extension GradesViewController: AddTermViewControllerDelegate {
    
    func shouldRefresh() {
        fetchTerms()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let indexPath = IndexPath(item: self.terms.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension GradesViewController: TermCollectionViewCellDelegate {
    
    func goToTermDetail(item: Int) {
        let term = terms[item]
        let viewController = TermDetailViewController()
        viewController.term = term
        present(viewController, animated: true)
    }
}
