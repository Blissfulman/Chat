//
//  UITableView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.11.2021.
//

import UIKit

extension UITableView {
    
    func registerCell<T: UITableViewCell>(type: T.Type) {
        register(type, forCellReuseIdentifier: String(describing: type))
    }
    
    func dequeue<T: UITableViewCell>(type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }
}
