//
//  ConfigurableCell.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 07.10.2021.
//

import UIKit

protocol ConfigurableCell: UITableViewCell {
     associatedtype ConfigurationModel
     func configure(with model: ConfigurationModel)
}
