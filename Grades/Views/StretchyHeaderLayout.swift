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
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        layoutAttributes?.forEach({ (attributes) in
            if attributes.representedElementKind == UICollectionView.elementKindSectionHeader {
                
                guard let collectionView = collectionView else { return }
                let contentOffsetY = collectionView.contentOffset.y
                
                let width = collectionView.frame.width
                let height = attributes.frame.height - contentOffsetY
                
                if collectionView.frame.height * 0.3 < height {
                    attributes.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                }
                
                
            }
        })
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

}
