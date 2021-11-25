//
//  CoreDataStorageImpl.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 17.11.2021.
//

import CoreData

final class CoreDataStorageImpl: CoreDataStorage {
    
    // MARK: - Private properties
    
    private let persistentContainer: NSPersistentContainer
    private var backgroundContext: NSManagedObjectContext!
    
    // MARK: - Initialization
    
    init(modelName: String) {
        self.persistentContainer = NSPersistentContainer(name: modelName)
        createStack()
    }
    
    // MARK: - Public methods
    
    func createObject<T: NSManagedObject>(from entity: T.Type, completion: @escaping (T) -> Void) {
        backgroundContext.createObject(completion: completion)
    }
    
    func deleteObjects(_ objects: [NSManagedObject]) {
        backgroundContext.deleteObjects(objects)
    }
    
    func saveChanges() {
        backgroundContext.saveChanges()
    }
    
    func fetchObjects<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil) -> [T] {
        var fetchedResult = [T]()
        let entityName = String(describing: entity)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        
        do {
            fetchedResult = try backgroundContext.fetch(request)
        } catch {
            DebugLogger.log("Could not fetch: \(error.localizedDescription)")
        }
        return fetchedResult
    }
    
    func fetchedResultsController<T: NSManagedObject>(
        for entity: T.Type,
        sortDescriptorKey: String,
        predicate: NSCompoundPredicate? = nil
    ) -> NSFetchedResultsController<T> {
        let entityName = String(describing: entity)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        request.fetchBatchSize = 10
        
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: backgroundContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        do {
            try controller.performFetch()
        } catch {
            DebugLogger.log("Could not fetch: \(error.localizedDescription)")
        }
        return controller
    }
    
    // MARK: - Private methods
    
    private func createStack() {
        persistentContainer.loadPersistentStores { [weak self] _, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.backgroundContext = self.persistentContainer.newBackgroundContext()
            self.backgroundContext.mergePolicy = NSMergePolicy.overwrite
        }
    }
}
