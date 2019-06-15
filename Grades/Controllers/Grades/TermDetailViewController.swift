//
//  TermDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermDetailViewController: BaseViewController {
    
    var collectionView: UICollectionView!
    var term: Term = Term()
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = term.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateSubject))
        navigationItem.rightBarButtonItem = addButton
    }

    override func setupView() {
        super.setupView()
        
        let layout = FixedHeaderLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.anchor
            .edgesToSuperview(toSafeArea: true)
            .activate()
        collectionView.register(SubjectCollectionViewCell.self)
        collectionView.register(TermDetailCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TermDetailCollectionViewHeader")
    }
    
    @objc private func goToCreateSubject() {
        // TODO: Implement code
    }

}

extension TermDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCollectionViewCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TermDetailCollectionViewHeader", for: indexPath) as! TermDetailCollectionViewHeader
            header.delegate = self
            header.configureWith(term)
            return header
        }
        fatalError("Header missing")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let estimatedHeight = collectionView.frame.height * 0.3
        return CGSize(width: collectionView.frame.width, height: estimatedHeight > 140 ? 140 : estimatedHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}

extension TermDetailViewController: TermDetailCollectionViewHeaderDelegate {
    
    func dismissView() {
        dismiss(animated: true)
    }
}
