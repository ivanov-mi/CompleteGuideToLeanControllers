//
//  ShoppingListDataSource.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 7/16/24.
//

import UIKit

class ShoppingListDataSource: NSObject, UITableViewDataSource, ShoppingListDataProviderDelegate {
    
    var cellIdentifier: String
    var tableView: UITableView
    var shoppingListDataProvider: ShoppingListDataProvider

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = shoppingListDataProvider.sections else {
            return 1
        }
        
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let shoppingList = shoppingListDataProvider.object(at: indexPath)
            
            shoppingListDataProvider.delete(shoppingList: shoppingList)
        }
        
        tableView.isEditing = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        let shoppingList = shoppingListDataProvider.object(at: indexPath)
        
        cell.textLabel?.text = shoppingList.title
        
        return cell
    }
    
    func shoppingListDataProviderDidInsert(at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func shoppingListDataProviderDidDelete(at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    init(cellIdentifier: String, tableView: UITableView, shoppingListDataProvider: ShoppingListDataProvider) {
        self.cellIdentifier = cellIdentifier
        self.tableView = tableView
        self.shoppingListDataProvider = shoppingListDataProvider
        
        super.init()
        self.shoppingListDataProvider.delegate = self
    }
}
