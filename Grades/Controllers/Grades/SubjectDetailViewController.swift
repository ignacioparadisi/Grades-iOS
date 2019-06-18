//
//  SubjectDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 6/15/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectDetailViewController: BaseViewController {

    var collectionView: UICollectionView!
    var subject: Subject = Subject()
    var assignments: [Assignment] = []
    weak var delegate: CreateSubjectViewControllerDelegate?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = subject.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateAssignment))
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
        collectionView.register(DetailCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailCollectionViewHeader")
        
        fetchAssignments()
    }
    
    @objc private func goToCreateAssignment() {
        let controller = CreateAssignmentViewController()
        controller.subject = subject
        controller.delegate = self
        present(UINavigationController(rootViewController: controller), animated: true)
    }
    
    private func fetchAssignments() {
        assignments = ServiceFactory.createService(.realm).fetchAssignments(for: subject)
        collectionView.reloadData()
    }

}

extension SubjectDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assignments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCollectionViewCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailCollectionViewHeader", for: indexPath) as! DetailCollectionViewHeader
            header.configureWith(subject)
            return header
        }
        fatalError("Header missing")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let estimatedHeight = collectionView.frame.height * 0.3
        return CGSize(width: collectionView.frame.width, height: estimatedHeight > 140 ? 140 : estimatedHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}

extension SubjectDetailViewController: CreateAssignmentViewControllerDelegate {
    
    func didCreateAssignment() {
        fetchAssignments()
        delegate?.shouldRefresh()
    }
    
}
