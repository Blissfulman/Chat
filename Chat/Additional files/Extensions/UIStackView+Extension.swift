//
//  UIStackView+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 27.09.2021.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}
