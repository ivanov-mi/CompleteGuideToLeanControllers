//
//  ShoppingListDataProvider.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 7/15/24.
//

import Foundation
import CoreData

class ShoppingListDataProvider: NSObject, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!
    var sections: [NSFetchedResultsSectionInfo]? {
        fetchResultsController.sections
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        super.init()
        
        let request = NSFetchRequest<ShoppingList>(entityName: "ShoppingList")
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchResultsController.delegate = self
        
        try! self.fetchResultsController.performFetch()
    }
    
    func object(at indexPath: IndexPath) -> ShoppingList {
        fetchResultsController.object(at: indexPath)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
//        if type == .insert {
//            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
//        } else if type == .delete {
//            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
//        }
    }
}
