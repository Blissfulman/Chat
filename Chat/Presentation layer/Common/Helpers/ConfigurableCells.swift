//
//  ConfigurableCells.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

import UIKit

protocol ConfigurableTableCell: UITableViewCell {
     associatedtype ConfigurationModel
     func configure(with model: ConfigurationModel)
}

protocol ConfigurableCollectionCell: UICollectionViewCell {
     associatedtype ConfigurationModel
     func configure(with model: ConfigurationModel)
}
