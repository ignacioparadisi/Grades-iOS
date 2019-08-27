//
//  UITableView+Extension.swift
//  Grades
//
//  Created by Ignacio Paradisi on 5/1/19.
//  Copyright © 2019 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Registers a UITableViewCell into a UITableView
    ///
    /// - Parameter _: UITableViewCell subclass to be registered
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    /// Dequeues cell if UITableViewCell subclass comforms ReusableView protocol
    ///
    /// - Parameter indexPath: IndexPath of UITableViewCell
    /// - Returns: UITableViewCell dequed
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }
        return cell
    }
}
