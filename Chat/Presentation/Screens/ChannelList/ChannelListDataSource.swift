//
//  ChannelListDataSource.swift
//  Chat
//
//  Created by Evgeny Novgorodov on 08.11.2021.
//

import UIKit
import CoreData

protocol ChannelListDataSourceProtocol {
    var tableView: UITableView? { get set }
    func getChannel(at indexPath: IndexPath) -> Channel?
}

final class ChannelListDataSource: NSObject, ChannelListDataSourceProtocol {
    
    // MARK: - Public properties
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.dataSource = self
        }
    }
    
    // MARK: - Private properties
    
    private lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = {
        let fetchedResultsController = DataStorageManager.shared.channelListFetchedResultsController
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    // MARK: - Public methods
    
    func getChannel(at indexPath: IndexPath) -> Channel? {
        let object = fetchedResultsController.object(at: indexPath)
        return Channel(dbChannel: object)
    }
}

// MARK: - UITableViewDataSource

extension ChannelListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let channel = Channel(dbChannel: fetchedResultsController.object(at: indexPath)),
            let cell = tableView.dequeue(type: ChannelCell.self, for: indexPath)
        else {
            return UITableViewCell()
        }
        cell.configure(with: channel)
        return cell
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelListDataSource: NSFetchedResultsControllerDelegate {
    
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
                tableView?.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                guard
                    let channel = Channel(dbChannel: fetchedResultsController.object(at: indexPath)),
                    let cell = tableView?.dequeue(type: ChannelCell.self, for: indexPath)
                else { return }
                
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath {
                tableView?.deleteRows(at: [indexPath], with: .automatic)
            }
            if let indexPath = newIndexPath {
                tableView?.insertRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError(debugDescription)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.endUpdates()
    }
}
