//
//  ChannelDataSource.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.11.2021.
//

import UIKit
import CoreData

protocol ChannelDataSourceProtocol {
    var tableView: UITableView? { get set }
}

final class ChannelDataSource: NSObject, ChannelDataSourceProtocol {
    
    // MARK: - Public properties
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
        }
    }
    
    // MARK: - Private properties
    
    private let fetchedResultsController: NSFetchedResultsController<DBMessage>
    
    // MARK: - Initialization
    
    init(channel: Channel) {
        fetchedResultsController = DataStorageManager.shared.channelFetchedResultsController(forChannel: channel)
        super.init()
        fetchedResultsController.delegate = self
    }
}

// MARK: - UITableViewDataSource

extension ChannelDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let firstSection = fetchedResultsController.sections?.first else { return 0 }
        return firstSection.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let message = Message(dbMessage: fetchedResultsController.object(at: indexPath)),
            let cell = tableView.dequeue(type: MessageCell.self, for: indexPath)
        else {
            return UITableViewCell()
        }
        cell.configure(with: message)
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelDataSource: NSFetchedResultsControllerDelegate {
    
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
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                guard
                    let message = Message(dbMessage: fetchedResultsController.object(at: indexPath)),
                    let cell = tableView?.dequeue(type: MessageCell.self, for: indexPath)
                else { return }
                
                cell.configure(with: message)
            }
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .fade)
            }
        @unknown default:
            fatalError(debugDescription)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
