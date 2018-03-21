//
//  ViewController.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-16.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    // create new item array to hold values
    var itemArray = [Item]()
    
    // store user key value pairs to be stored persistently
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Eggos"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Destroy Demogorgon"
        itemArray.append(newItem3)

        
        // set to values set in default plist file (save/retrieve)
        // note user defaults are good for setting user settings (ie volume, country etc)
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
        
    }


    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        // populate text with current array item
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        // decide whether to show checkmark or not
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print # of row selected
        print(itemArray[indexPath.row])
        
        // sets done property on current property to opposite of what it is now
        itemArray[indexPath.row].done = !itemArray[index.row].done
        
        // reload data so checkmarks appear
        tableView.reloadData()

        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            // APpend new item to array
            self.itemArray.append(newItem)
            // set in user defaults plist file
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            // reload table
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // alertTextField scope ends in this closure, assign to global var textField
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

