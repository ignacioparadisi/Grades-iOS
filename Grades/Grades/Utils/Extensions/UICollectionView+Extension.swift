//
//  UICollectionView+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//
import UIKit

extension UICollectionView {
    
    /// Registers a UICollectionViewCell into a UICollectionView
    ///
    /// - Parameter _: UICollectionViewCell subclass to be registered
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
    }
    
    /// Dequeues cell if UICollectionViewCell subclass comforms ReusableView protocol
    ///
    /// - Parameter indexPath: IndexPath of UICollectionViewCell
    /// - Returns: UICollectionViewCell dequed
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }
        return cell
    }
    
}
