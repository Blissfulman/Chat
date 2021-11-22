//
//  ImagePickerDataSource.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

protocol ImagePickerDataSourceProtocol {
    var collectionView: UICollectionView? { get set }
    
    func imageData(at indexPath: IndexPath) -> Data?
}

final class ImagePickerDataSource: NSObject, ImagePickerDataSourceProtocol {
    
    // MARK: - Public properties
    
    weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
            collectionView?.reloadData() // TEMP?
        }
    }
    
    // MARK: - Private properties
    
    private var images = [Data]()
    
    // MARK: - Public methods
    
    func imageData(at indexPath: IndexPath) -> Data? {
        nil
    }
}

// MARK: - UICollectionDataSource

extension ImagePickerDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeue(type: ImageCell.self, for: indexPath)
        else {
            return UICollectionViewCell()
        }
//        cell.configure(with: Data())
        return cell
    }
}
