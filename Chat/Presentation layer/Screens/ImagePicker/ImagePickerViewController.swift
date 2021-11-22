//
//  ImagePickerViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

protocol ImagePickerDisplayLogic: AnyObject {
    func displayDidPickImage(request: ImagePickerModel.PickImage.ViewModel)
}

final class ImagePickerViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let numberOfColumns: CGFloat = 3
        static let cellSpacing: CGFloat = 5
    }
    
    // MARK: - Private properties
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let size = (UIScreen.main.bounds.width - (Constants.numberOfColumns + 1) * Constants.cellSpacing)
            / Constants.numberOfColumns
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.minimumInteritemSpacing = Constants.cellSpacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).prepareForAutoLayout()
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.registerCell(type: ImageCell.self)
        return collectionView
    }()
    
    private let interactor: ImagePickerBusinessLogic
    private let router: ImagePickerRoutingLogic
    
    // MARK: - Initialization
    
    init(
        interactor: ImagePickerBusinessLogic,
        router: ImagePickerRoutingLogic,
        imagePickerDataSource: ImagePickerDataSourceProtocol
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
        var imagePickerDataSource = imagePickerDataSource
        imagePickerDataSource.collectionView = self.collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.cellSpacing
            ),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.cellSpacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.cellSpacing),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.cellSpacing)
        ])
    }
}

// MARK: - ImagePickerDisplayLogic

extension ImagePickerViewController: ImagePickerDisplayLogic {
    
    func displayDidPickImage(request: ImagePickerModel.PickImage.ViewModel) {
        router.back()
    }
}

// MARK: - UICollectionViewDelegate

extension ImagePickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didPickImage(request: ImagePickerModel.PickImage.Request(indexPath: indexPath))
    }
}
