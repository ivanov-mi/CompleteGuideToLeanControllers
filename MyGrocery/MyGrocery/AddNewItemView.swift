//
//  AddNewItemView.swift
//  MyGrocery
//
//  Created by Martin Ivanov on 7/16/24.
//

import UIKit

class AddNewItemView: UIView, UITextFieldDelegate {
    
    var placeholderText: String
    var addNewItem: (String) -> ()
    
    init(controller: UIViewController, placeholderText: String, addNewItem: @escaping (String) -> ()) {
        self.placeholderText = placeholderText
        self.addNewItem = addNewItem
        super.init(frame: controller.view.frame)
        
        setup()
    }
    
    private func setup() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.lightText
        
        let textField = UITextField(frame: headerView.frame)
        textField.placeholder = placeholderText
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.delegate = self
        
        headerView.addSubview(textField)
        addSubview(headerView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            addNewItem(text)
        }
        
        textField.text = nil
        
        return textField.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
