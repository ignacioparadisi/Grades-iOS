//
//  TermCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol TermCollectionViewCellDelegate: class {
    func goToTermDetail(index: Int)
    func showDeleteAlert(index: Int)
}

class TermCollectionViewCell: UICollectionViewCell, ReusableView {
    
    weak var delegate: TermCollectionViewCellDelegate?
    var collectionView: UICollectionView!
    var isInitialized: Bool = false
    var term: Term = Term()
    var subjects: [Subject] = []
    
    init(term: Term) {
        super.init(frame: .zero)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if !isInitialized {
            initialize()
            isInitialized = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if !isInitialized {
           initialize()
            isInitialized = true
        }
    }
    
    private func initialize() {
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        
        let layout = StretchyHeaderLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: frame.width, height: 67)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGray5
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.cornerRadius = 10
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: frame.height * 0.3 + 16, left: 0, bottom: 16, right: 0)
        contentView.addSubview(collectionView)
        collectionView.anchor.edgesToSuperview().activate()
        
        collectionView.register(SubjectCardCollectionViewCell.self)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToTermDetail(gestureRecognizer:)))
        addGestureRecognizer(tapGesture)
    }
    
    func configure(with term: Term) {
        self.term = term
        subjects = term.getSubjects()
        refreshTable()
    }
    
    private func addSubjectView() {
        let label = UILabel()
        label.text = "This term has no subjects"
        // label.textColor = ThemeManager.currentTheme.placeholderColor
        
        addSubview(label)
        label.anchor
            .centerToSuperview()
            .activate()
    }
    
    @objc private func goToTermDetail(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            delegate?.goToTermDetail(index: tag)
        default:
            break
        }
        
    }
    
    @objc private func goToAddSubject() {
        print("Add subject button tapped")
    }
    
    private func refreshTable() {
//        if subjects.isEmpty {
//            addSubjectView()
//        }
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

}

extension TermCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subjects.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
            header.configureWith(term: term)
            return header
        }
        fatalError("Header missing")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let estimatedHeight = collectionView.frame.height * 0.3
        return CGSize(width: collectionView.frame.width, height: estimatedHeight > 140 ? 140 : estimatedHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = indexPath.item
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCardCollectionViewCell
        cell.configure(with: subjects[item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 16, right: 0)
    }

}
