//
//  UICollectionView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

extension UICollectionView {
    
    func registerCell<T: UICollectionViewCell>(type: T.Type) {
        register(type, forCellWithReuseIdentifier: String(describing: type))
    }
    
    func dequeue<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }
}
