//
//  ImagePickerDataSource.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

protocol ImagePickerDataSourceProtocol {
    var collectionView: UICollectionView? { get set }
    
    func appendImageItems(_ imageItems: [ImageItem])
    func imageItem(at indexPath: IndexPath) -> ImageItem
}

final class ImagePickerDataSource: NSObject, ImagePickerDataSourceProtocol {
    
    // MARK: - Public properties
    
    weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.dataSource = self
        }
    }
    
    // MARK: - Private properties
    
    private var imageItems = [ImageItem]()
    
    // MARK: - Public methods
    
    func appendImageItems(_ items: [ImageItem]) {
        guard !items.isEmpty else { return }
        self.imageItems += items
        let numberOfItems = collectionView?.numberOfItems(inSection: 0) ?? 0
        let appendingIndexPathes = (numberOfItems...(numberOfItems + items.count - 1))
            .map { IndexPath(item: $0, section: 0) }
        collectionView?.insertItems(at: appendingIndexPathes)
    }
    
    func imageItem(at indexPath: IndexPath) -> ImageItem {
        imageItems[indexPath.row]
    }
}

// MARK: - UICollectionDataSource

extension ImagePickerDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageItems.count
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
        if let url = imageItems[indexPath.row].previewURL {
            cell.configure(with: url)
        }
        return cell
    }
}
