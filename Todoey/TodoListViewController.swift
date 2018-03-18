//
//  ViewController.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-16.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    // store user key value pairs to be stored persistently
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set to values set in default plist file (save/retrieve)
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }


    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // populate text with current array item
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print # of row selected
        print(itemArray[indexPath.row])
        
        // place checkmark next to cells selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // change highlighted color
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // popup with textfield appears after pressed
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks add item button on our uialert
            print(textField.text)
            // APpend new item to array
            self.itemArray.append(textField.text!)
            // set in user defaults plist file
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // reload table
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // alertTextField scope ends in this closure, assign to global var textField
            textField = alertTextField
            print(alertTextField.text)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

