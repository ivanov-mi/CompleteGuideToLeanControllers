//
//  FetchedResultsProvider.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 9/16/24.
//

import Foundation
import CoreData

protocol FetchedResultsProviderDelegate: AnyObject {
    func fetchedResultsProviderDidInsert(at indexPath: IndexPath)
    func fetchedResultsProviderDidDelete(at indexPath: IndexPath)
}

class FetchedResultsProvider<T>: NSObject, NSFetchedResultsControllerDelegate where T:NSManagedObject, T:ManagedObjectType {
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<T>!
    
    weak var delegate: FetchedResultsProviderDelegate?
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        
        let request = NSFetchRequest<T>(entityName: T.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        self.fetchedResultsController.delegate = self
        try! self.fetchedResultsController.performFetch()
    }
    
    func numberOfSections() -> Int {
        fetchedResultsController.sections?.count ?? 0
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    func objectAtIndex(indexPath: IndexPath) -> T {
        fetchedResultsController.object(at: indexPath)
    }
    
    func delete(model: T) {
        managedObjectContext.delete(model)
        try! managedObjectContext.save()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if type == .insert {
            if let newIndexPath {
                delegate?.fetchedResultsProviderDidInsert(at: newIndexPath)
            }
        } else if type == .delete {
            if let indexPath {
                delegate?.fetchedResultsProviderDidDelete(at: indexPath)
            }
        }
    }
}

