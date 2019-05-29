//
//  TermCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermCollectionViewCell: UICollectionViewCell, ReusableView, NibLoadableView {
    
    var collectionView: UICollectionView!
    var isInitialized: Bool = false
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if !isInitialized {
            initialize()
            isInitialized = true
        }
    }
    
    private func initialize() {
        backgroundColor = ThemeManager.currentTheme.cardBackgroundColor
        layer.cornerRadius = 10
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        addSubview(collectionView)
        collectionView.anchor.edgesToSuperview().activate()
        
        collectionView.register(SubjectCollectionViewCell.self)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
    }

}

extension UICollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as! HeaderCollectionReusableView
        header.configureWith(qualification: 9)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let estimatedHeight = collectionView.frame.height * 0.3
        return CGSize(width: collectionView.frame.width, height: estimatedHeight > 140 ? 140 : estimatedHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCollectionViewCell
        cell.backgroundColor = .black
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

}
