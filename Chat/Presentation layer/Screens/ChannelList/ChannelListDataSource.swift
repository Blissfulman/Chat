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
    
    func сhannel(at indexPath: IndexPath) -> Channel?
}

final class ChannelListDataSource: NSObject, ChannelListDataSourceProtocol {
    
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
    
    private let fetchedResultsController: NSFetchedResultsController<DBChannel>
    private var fetchedResultsControllerDelegate: FetchedResultsControllerDelegate?
    
    // MARK: - Initialization
    
    init(fetchedResultsController: NSFetchedResultsController<DBChannel>) {
        self.fetchedResultsController = fetchedResultsController
    }
    
    // MARK: - Public methods
    
    func сhannel(at indexPath: IndexPath) -> Channel? {
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
