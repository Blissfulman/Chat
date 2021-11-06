//
//  FirestoreManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 04.11.2021.
//

import Firebase

protocol FirestoreManagerProtocol {
    associatedtype Object: FirestoreObject
    typealias Listener = (Result<[Object], Error>) -> Void
}

final class FirestoreManager<Type: FirestoreObject>: FirestoreManagerProtocol {
    
    typealias Object = Type
    
    // MARK: - Nested types
    
    enum DataType {
        case channels
        case messages(channelID: String)
    }
    
    // MARK: - Public properties
    
    var listener: Listener? {
        didSet {
            setupFirestoreListener()
        }
    }
    
    // MARK: - Private properties
    
    private let database = Firestore.firestore()
    private let reference: CollectionReference
    
    // MARK: - Initialization
    
    init(dataType: DataType) {
        switch dataType {
        case .channels:
            reference = database.collection("channels")
        case let .messages(channelID):
            reference = database.collection("channels").document(channelID).collection("messages")
        }
    }
    
    // MARK: - Public methods
    
    func addObject(_ object: Object) {
        reference.addDocument(data: object.toDictionary)
    }
    
    // MARK: - Private methods
    
    private func setupFirestoreListener() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.listener?(.failure(error))
            } else {
                guard let objectSnapshots = snapshot?.documents else { return }
                let objects = objectSnapshots.compactMap { Object(snapshot: $0) }
                self.listener?(.success(objects))
            }
        }
    }
}
