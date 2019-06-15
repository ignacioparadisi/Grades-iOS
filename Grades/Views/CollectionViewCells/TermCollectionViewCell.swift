//
//  TermCollectionViewCell.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol TermCollectionViewCellDelegate: class {
    func goToTermDetail(item: Int)
}

class TermCollectionViewCell: UICollectionViewCell, ReusableView {
    
    weak var delegate: TermCollectionViewCellDelegate?
    var collectionView: UICollectionView!
    var isInitialized: Bool = false
    var term: Term = Term()  {
//        didSet {
//            if subjects.isEmpty {
//                fetchSubjects()
//            }
//        }
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    var subjects: [Subject] = [
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10),
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10),
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10),
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10),
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10),
        Subject(name: "Calculo", qualification: 10, maxQualification: 20, minQualification: 10)
    ]
    
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
        
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 10
        self.layer.shadowOpacity = 0.6
        self.layer.masksToBounds = false
        
        let layout = UICollectionViewFlowLayout() // StretchyHeaderLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: frame.width, height: 60)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: frame.height * 0.3 + 16, left: 0, bottom: 16, right: 0)
        addSubview(collectionView)
        collectionView.anchor.edgesToSuperview().activate()
        
        collectionView.register(SubjectCollectionViewCell.self)
         collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
        // TODO: Verificar si esto está bien
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hola(gestureRecognizer:)))
        collectionView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func hola(gestureRecognizer: UIGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            delegate?.goToTermDetail(item: tag)
        default:
            break
        }
        
    }
    
    private func fetchSubjects() {
        // subjects = RealmManager.shared.getArray(ofType: Subject.self, filter: "term.id == '\(term.id)'") as! [Subject]
        collectionView.reloadData()
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
        let cell = collectionView.dequeueReusableCell(for: indexPath) as SubjectCollectionViewCell
        cell.configureWith(subject: subjects[item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 16, right: 0)
    }

}
