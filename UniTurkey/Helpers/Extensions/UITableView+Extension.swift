//
//  UITableView+Extension.swift
//  UniTurkey
//
//  Created by Ali Çolak on 5.04.2024.
//

import UIKit

extension UITableView {
    
    // MARK: - Register
    
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }
    
    // MARK: - Dequeue
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier) as? T
        else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
    
    func isSection(at indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }
    
    func numberOfRowsWithSection(numberOfRows: Int) -> Int {
        return numberOfRows + 1
    }
    
    func indexWithSection(from indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row + 1, section: indexPath.section)
    }
    
    func indexWithoutSection(from indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row - 1, section: indexPath.section)
    }
    
}
