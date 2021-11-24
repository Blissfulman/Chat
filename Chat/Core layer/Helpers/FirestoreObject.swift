//
//  FirestoreObject.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 06.11.2021.
//

import Firebase

protocol FirestoreObject {
    var id: String { get } // Необходимо для возможности удалять объекты по их ID
    var toDictionary: [String: Any] { get }
    
    init?(snapshot: QueryDocumentSnapshot)
}
