//
//  TermDetailViewController.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/31/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermDetailViewController: BaseViewController {
    
    let chartSection: Int = 0
    
    var collectionView: UICollectionView!
    var term: Term = Term()
    var subjects: [Subject] = []
    weak var delegate: CreateTermViewControllerDelegate?
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = term.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCreateSubject))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func goBack() {
        dismiss(animated: true)
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
        collectionView.register(BarChartCollectionViewCell.self)
        collectionView.register(DetailCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "DetailCollectionViewHeader")
        
        fetchSubjects()
    }
    
    @objc private func goToCreateSubject() {
        let viewController = CreateSubjectViewController()
        viewController.delegate = self
        viewController.term = term
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func fetchSubjects() {
        subjects = ServiceFactory.createService(.realm).fetchSubjects(for: term)
        term.subjects = subjects
        collectionView.reloadData()
    }

}

extension TermDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case chartSection:
            return 1
        default:
            return subjects.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        
        switch section {
        case chartSection:
            let cell = collectionView.dequeueReusableCell(for: indexPath) as BarChartCollectionViewCell
            cell.configure(with: subjects)
            return cell
        default:
            let index = indexPath.item
            let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCollectionViewCell
            cell.configure(with: subjects[index])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section != chartSection {
            let index = indexPath.item
            let subject = subjects[index]
            let viewController = SubjectDetailViewController()
            viewController.delegate = self
            viewController.subject = subject
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DetailCollectionViewHeader", for: indexPath) as! DetailCollectionViewHeader
            header.configureWith(term)
            return header
        }
        fatalError("Header missing")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            let estimatedHeight = collectionView.frame.height * 0.3
            return CGSize(width: collectionView.frame.width, height: estimatedHeight > 140 ? 140 : estimatedHeight)
        default:
            return CGSize(width: 0, height: 0)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section: Int = indexPath.section
        let width: CGFloat = collectionView.frame.width
        var height: CGFloat = 80
        
        if section == chartSection {
            height = 200
        }
        
        return CGSize(width: width, height: height)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
}

extension TermDetailViewController: CreateSubjectViewControllerDelegate {
    func shouldRefresh() {
        fetchSubjects()
        delegate?.shouldRefresh()
    }
}
