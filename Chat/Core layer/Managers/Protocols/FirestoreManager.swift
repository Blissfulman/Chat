//
//  FirestoreManager.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 04.11.2021.
//

import Foundation

protocol FirestoreManager {
    associatedtype Object: FirestoreObject
    typealias Listener = (Result<SnapshotObjects<Object>, Error>) -> Void
    
    /// Слушатель изменений в хранилище Firestore.
    var listener: Listener? { get set }
    
    /// Добавление объекта в хранилище.
    /// - Parameter object: Добавляемый объект.
    func addObject(_ object: Object)
    /// Удаление объекта из хранилища.
    /// - Parameter object: Удаляемый объект.
    func deleteObject(_ object: Object)
}
