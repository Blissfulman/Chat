//
//  CoreDataStorage.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 03.11.2021.
//

import CoreData

/// Хранилище CoreData.
protocol CoreDataStorage {
    /// Создание объекта в контексте (выполняется в бэкграунд контексте).
    /// - Parameters:
    ///   - entity: Сущность объекта.
    ///   - completion: Обработчик завершения, в который возращается результат.
    func createObject<T: NSManagedObject>(from entity: T.Type, completion: @escaping (T) -> Void)
    /// Удаление объекта из хранилища (выполняется в бэкграунд контексте).
    /// - Parameter objects: Удаляемый объект.
    func deleteObjects(_ objects: [NSManagedObject])
    /// Сохранение всех имеющихся в контексте изменений (выполняется в бэкграунд контексте).
    func saveChanges()
    /// Получение объектов из хранилища (выполняется в бэкграунд контексте).
    /// - Parameters:
    ///   - entity: Сущность объектов.
    ///   - predicate: Предикат запроса.
    func fetchObjects<T: NSManagedObject>(for entity: T.Type, predicate: NSCompoundPredicate?) -> [T]
    /// Экземпляр `NSFetchedResultsController`, отслеживающий имеющиеся в хранилище объекты.
    ///
    /// Отслеживание выполняется в бэкграунд контексте.
    /// - Parameters:
    ///   - entity: Сущность объектов.
    ///   - sortDescriptorKey: Ключ дескриптора сортировки.
    ///   - predicate: Предикат запроса.
    func fetchedResultsController<T: NSManagedObject>(
        for entity: T.Type,
        sortDescriptorKey: String,
        predicate: NSCompoundPredicate?
    ) -> NSFetchedResultsController<T>
}
