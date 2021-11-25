//
//  FetchedResultsControllerDelegate.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 10.11.2021.
//

import UIKit
import CoreData

final class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    // MARK: - Private properties
    
    private weak var tableView: UITableView?
    
    // MARK: - Initialization
    
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.beginUpdates()
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView?.reloadRows(at: [indexPath], with: .automatic)
        case .move:
            guard
                let indexPath = indexPath,
                let newIndexPath = newIndexPath
            else { return }
            tableView?.deleteRows(at: [indexPath], with: .automatic)
            tableView?.insertRows(at: [newIndexPath], with: .automatic)
        @unknown default:
            fatalError(debugDescription)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
