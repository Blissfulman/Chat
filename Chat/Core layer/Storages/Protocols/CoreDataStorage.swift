//
//  CoreDataStorage.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

protocol CoreDataStorage {
    func createObject<T: NSManagedObject>(from entity: T.Type, completion: @escaping (T) -> Void)
    func deleteObjects(_ objects: [NSManagedObject])
    func saveChanges()
    func fetchObjects<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate?) -> [T]
    func fetchedResultsController<T: NSManagedObject>(
        for entity: T.Type,
        sortDescriptorKey: String,
        predicate: NSCompoundPredicate?
    ) -> NSFetchedResultsController<T>
}
