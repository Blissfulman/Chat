//
//  NSManagedObjectContext+Extension.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

extension NSManagedObjectContext {
    
    func createObject<T: NSManagedObject>(completion: @escaping (T) -> Void) {
        performAndWait {
            guard
                let entityName = T.entity().name,
                let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: self) as? T
            else {
                fatalError("Can't insert new object")
            }
            completion(object)
        }
    }
    
    func deleteObjects(_ objects: [NSManagedObject]) {
        performAndWait {
            objects.forEach { delete($0) }
        }
    }
    
    func saveChanges() {
        performAndWait {
            guard hasChanges else { return }
            
            do {
                try save()
            } catch {
                DebugLogger.log("Saving changes failed with error: \(error.localizedDescription)")
            }
        }
    }
}
