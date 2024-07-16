//
//  ShoppingListsTableTableViewController.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 7/11/24.
//

import UIKit
import CoreData

class ShoppingListsTableTableViewController: UITableViewController, UITextFieldDelegate {
    
    var shoppingListDataProvider: ShoppingListDataProvider!
    var shoppingListDataSource: ShoppingListDataSource!
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ShoppingListTableViewCell")
        populateShoppingLists()
    }
    
    private func populateShoppingLists() {
        shoppingListDataProvider = ShoppingListDataProvider(managedObjectContext: managedObjectContext)
        shoppingListDataSource = ShoppingListDataSource(cellIdentifier: "ShoppingListTableViewCell", tableView: self.tableView, shoppingListDataProvider: shoppingListDataProvider)
        
        tableView.dataSource = shoppingListDataSource
    }
        
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let addNewItemView = AddNewItemView(controller: self, placeholderText: "Enter Shopping List") { title in
            self.addNewShoppingList(title: title)
        }
        
        return addNewItemView
    }
    
    private func addNewShoppingList(title: String) {
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: self.managedObjectContext) as! ShoppingList
        
        shoppingList.title = title
        try! self.managedObjectContext.save()
    }
}
