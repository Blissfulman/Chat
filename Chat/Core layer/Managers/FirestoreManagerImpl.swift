//
//  FirestoreManagerImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import Firebase

final class FirestoreManagerImpl<Type: FirestoreObject>: FirestoreManager {
    
    typealias Object = Type
    
    // MARK: - Nested types
    
    enum DataType {
        case channels
        case messages(channelID: Channel.ID)
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
    
    func deleteObject(_ object: Object) {
        database.collection("channels").document(object.id).delete()
    }
    
    // MARK: - Private methods
    
    private func setupFirestoreListener() {
        reference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                self.listener?(.failure(error))
            } else {
                guard let objectSnapshots = snapshot?.documentChanges else { return }
                
                let snapshotObjects: SnapshotObjects = (
                    addedObjects: objectSnapshots
                        .filter { $0.type == .added }
                        .compactMap { Object(snapshot: $0.document) },
                    modifiedObjects: objectSnapshots
                        .filter { $0.type == .modified }
                        .compactMap { Object(snapshot: $0.document) },
                    removedObjects: objectSnapshots
                        .filter { $0.type == .removed }
                        .compactMap { Object(snapshot: $0.document) }
                )
                self.listener?(.success(snapshotObjects))
            }
        }
    }
}
