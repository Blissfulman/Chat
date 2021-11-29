//
//  ImagePickerViewController.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 20.11.2021.
//

import UIKit

protocol ImagePickerDisplayLogic: AnyObject {
    func displayTheme(viewModel: ImagePickerModel.SetupTheme.ViewModel)
    func displayImages(viewModel: ImagePickerModel.FetchImages.ViewModel)
    func displayDidPickImage(viewModel: ImagePickerModel.PickImage.ViewModel)
}

final class ImagePickerViewController: UIViewController {
    
    // MARK: - Nested types
    
    private enum Constants {
        static let numberOfColumns: CGFloat = 3
        static let cellSpacing: CGFloat = 5
    }
    
    // MARK: - Private properties
    
    private lazy var topBarView: TopBarView = {
        let view = TopBarView(rightButtonTitle: "Close", rightButtonAction: closeButtonTapped)
        return view
    }()
    
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
    
    private let progressView = ProgressView()
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
        imagePickerDataSource.collectionView = collectionView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let queryAlertController = queryAlertController(okActionHandler: { [weak self] query in
            guard let self = self else { return }
            self.progressView.show()
            self.interactor.fetchImages(request: ImagePickerModel.FetchImages.Request(query: query))
        })
        present(queryAlertController, animated: true)
    }
    
    // MARK: - Actions
    
    private func closeButtonTapped() {
        router.back()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        view.roundCorners([.topLeft, .topRight], radius: 18)
        view.backgroundColor = .white
        view.addSubview(topBarView)
        view.addSubview(collectionView)
        view.addSubview(progressView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBarView.heightAnchor.constraint(equalToConstant: 70),
                                            
            collectionView.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: Constants.cellSpacing),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.cellSpacing),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.cellSpacing),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.cellSpacing),
            
            progressView.topAnchor.constraint(equalTo: topBarView.bottomAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureUI() {
        interactor.setupTheme(request: ImagePickerModel.SetupTheme.Request())
    }
    
    private func queryAlertController(okActionHandler: @escaping (String) -> Void) -> UIAlertController {
        let queryAlertController = UIAlertController(
            title: "Enter query for images",
            message: nil,
            preferredStyle: .alert
        )
        queryAlertController.addTextField { textField in
            textField.placeholder = "query"
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            okActionHandler(queryAlertController.textFields?.first?.text ?? "")
        }
        queryAlertController.addAction(okAction)
        return queryAlertController
    }
}

// MARK: - ImagePickerDisplayLogic

extension ImagePickerViewController: ImagePickerDisplayLogic {
    
    func displayTheme(viewModel: ImagePickerModel.SetupTheme.ViewModel) {
        topBarView.setTheme(viewModel.theme)
    }
    
    func displayImages(viewModel: ImagePickerModel.FetchImages.ViewModel) {
        progressView.hide()
    }
    
    func displayDidPickImage(viewModel: ImagePickerModel.PickImage.ViewModel) {
        router.back()
    }
}

// MARK: - UICollectionViewDelegate

extension ImagePickerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        interactor.didPickImage(request: ImagePickerModel.PickImage.Request(indexPath: indexPath))
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        interactor.fetchMoreImages(request: ImagePickerModel.FetchMoreImages.Request(indexPath: indexPath))
    }
}
