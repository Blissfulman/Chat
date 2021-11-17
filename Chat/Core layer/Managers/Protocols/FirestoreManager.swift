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
}
