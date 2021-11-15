//
//  CoreDataStorage.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

final class CoreDataStorage {
    
    // MARK: - Private properties
    
    private let persistentContainer: NSPersistentContainer
    private var viewContext: NSManagedObjectContext!
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
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil) -> [T] {
        fetchData(for: entity, onContext: viewContext, predicate: predicate)
    }
    
    func fetchDataInBackground<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate? = nil) -> [T] {
        fetchData(for: entity, onContext: backgroundContext, predicate: predicate)
    }
    
    // MARK: - Private methods
    
    private func createStack() {
        persistentContainer.loadPersistentStores { [weak self] _, error in
            guard let self = self else { return }
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.viewContext = self.persistentContainer.viewContext
            self.backgroundContext = self.persistentContainer.newBackgroundContext()
            self.backgroundContext.mergePolicy = NSMergePolicy.overwrite
        }
    }
    
    private func fetchData<T: NSManagedObject>(
        for entity: T.Type,
        onContext context: NSManagedObjectContext,
        predicate: NSCompoundPredicate? = nil
    ) -> [T] {
        var fetchedResult = [T]()
        let entityName = String(describing: entity)
        let request: NSFetchRequest<T> = NSFetchRequest(entityName: entityName)
        request.predicate = predicate
        
        do {
            fetchedResult = try context.fetch(request)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        return fetchedResult
    }
}
