//
//  ShoppingListDataProvider.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 7/15/24.
//

import Foundation
import CoreData

protocol ShoppingListDataProviderDelegate: AnyObject {
    func shoppingListDataProviderDidInsert(at indexPath: IndexPath)
    func shoppingListDataProviderDidDelete(at indexPath: IndexPath)
}

class ShoppingListDataProvider: NSObject, NSFetchedResultsControllerDelegate {
    
    weak var delegate: ShoppingListDataProviderDelegate?
    var managedObjectContext: NSManagedObjectContext
    var fetchResultsController: NSFetchedResultsController<ShoppingList>!
    var sections: [NSFetchedResultsSectionInfo]? {
        fetchResultsController.sections
    }
    
    init(managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
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
    
    func delete(shoppingList: ShoppingList) {
        self.managedObjectContext.delete(shoppingList)
        try! managedObjectContext.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if type == .insert {
            if let newIndexPath {
                delegate?.shoppingListDataProviderDidInsert(at: newIndexPath)
            }
        } else if type == .delete {
            if let indexPath {
                delegate?.shoppingListDataProviderDidDelete(at: indexPath)
            }
        }
    }
}
