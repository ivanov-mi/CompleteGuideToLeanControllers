//
//  TableViewDataSource.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 9/17/24.
//

import UIKit
import CoreData

class TableViewDataSource<Cell: UITableViewCell, Model: NSManagedObject>: NSObject, UITableViewDataSource where Model: ManagedObjectType {
    
    var cellIdentifier: String
    var fetchedResultsProvider: FetchedResultsProvider<Model>
    var configureCell: (Cell, Model) -> ()
    var tableView: UITableView
    
    init(tableView: UITableView, cellIdentifier: String, fetchedResultsProvider: FetchedResultsProvider<Model>, configureCell: @escaping (Cell, Model) -> ()) {
        self.tableView = tableView
        self.cellIdentifier = cellIdentifier
        self.fetchedResultsProvider = fetchedResultsProvider
        self.configureCell = configureCell
        
        super.init()
        self.fetchedResultsProvider.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultsProvider.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fetchedResultsProvider.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell
        let model = fetchedResultsProvider.objectAtIndex(indexPath: indexPath)
        
        configureCell(cell, model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = fetchedResultsProvider.objectAtIndex(indexPath: indexPath)
            self.fetchedResultsProvider.delete(model: model)
        }
    }
}

extension TableViewDataSource: FetchedResultsProviderDelegate {
    func fetchedResultsProviderDidInsert(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func fetchedResultsProviderDidDelete(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
