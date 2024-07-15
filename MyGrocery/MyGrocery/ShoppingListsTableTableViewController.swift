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
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        populateShoppingLists()
    }
    
    private func populateShoppingLists() {
        shoppingListDataProvider = ShoppingListDataProvider(managedObjectContext: managedObjectContext)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let shoppingList = shoppingListDataProvider.object(at: indexPath)
            
            self.managedObjectContext.delete(shoppingList)
            try! self.managedObjectContext.save()
        }
        
        self.tableView.isEditing = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = shoppingListDataProvider.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let shoppingList = shoppingListDataProvider.object(at: indexPath)
        cell.textLabel?.text = shoppingList.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.lightText
        
        let textField = UITextField(frame: headerView.frame)
        textField.placeholder = "Enter Shopping List"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.delegate = self
        
        headerView.addSubview(textField)
        
        return headerView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let shoppingList = NSEntityDescription.insertNewObject(forEntityName: "ShoppingList", into: self.managedObjectContext) as! ShoppingList
        
        shoppingList.title = textField.text
        try! self.managedObjectContext.save()
        
        textField.text = nil
        
        return textField.resignFirstResponder()
    }
}
