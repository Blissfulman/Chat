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
            guard let tableView = tableView else { return }
            fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(tableView: tableView)
            fetchedResultsController.delegate = fetchedResultsControllerDelegate
            tableView.dataSource = self
        }
    }
    
    // MARK: - Private properties
    
    private let fetchedResultsController: NSFetchedResultsController<DBMessage>
    private var fetchedResultsControllerDelegate: FetchedResultsControllerDelegate?
    
    // MARK: - Initialization
    
    init(channel: Channel) {
        fetchedResultsController = DataStorageManager.shared.channelFetchedResultsController(forChannel: channel)
    }
}

// MARK: - UITableViewDataSource

extension ChannelDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections[section].numberOfObjects
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
