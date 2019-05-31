//
//  StretchyHeaderLayout.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/29/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

class StretchyHeaderLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        let attrs = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))
        if !layoutAttributes!.contains(attrs!) {
            layoutAttributes?.append(attrs!)
        }
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y
                
                let width = collectionView.frame.width
                let height = attributes.frame.height - contentOffsetY
                
                if collectionView.frame.height * 0.25 < height {
                    attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                } else {
                    attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: collectionView.frame.height * 0.25)
                    var frame = attributes.frame
                    let offsetY = collectionView.contentOffset.y
                    frame.origin.y = offsetY
                    attributes.frame = frame
                    attributes.zIndex = 99
                }
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
