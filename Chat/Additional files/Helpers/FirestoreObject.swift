//
//  FirestoreObject.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.11.2021.
//

import Firebase

protocol FirestoreObject {
    init?(snapshot: QueryDocumentSnapshot)
    var toDictionary: [String: Any] { get }
}
