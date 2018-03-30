//
//  ViewController.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-16.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // create new item array to hold values
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            // this will happen once selectedCategory is set
            loadItems()
        }
    }
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    // define context variable for coredata
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext



    override func viewDidLoad() {
        super.viewDidLoad()
    
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // load items from core data to table cells
        // loadItems()
        
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
        
        // To delete (order matters, must remove from context first)
        // context.delete(itemArray[indexPath.row]) # deletes from db
        // itemArray.remove(at: indexPath.row) # Deletes from array

        // sets done property on current property to opposite of what it is now
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // save data to database and commit
        self.saveItems()

        // change highlighted color
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //MARK: - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("add button pressed \n")
        var textField = UITextField()
        
        // popup with textfield appears after pressed
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once user clicks add item button on our uialert

            // initialize coredata item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            

            // save data to database
            self.saveItems()

            // reload table
            //self.tableView.reloadData()
            //print("table reloaded")

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            // alertTextField scope ends in this closure, assign to global var textField
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //Mark: - Model Manipulation Methods
    func saveItems() {
        // transfer from context to permenant data source
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()

    }
    
    // set default to select all (item.fetchrequest)
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // get items from core data
        //let request : NSFetchRequest<Item> = Item.fetchRequest()

        // Pull items belonging to category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        request.predicate = compoundPredicate

        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    

}

//MARK: - Search bar methods

// add delegate method for search bar
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //print(searchBar.text!)
        
        // fetch from core data w
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // fetch results
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            // no characters in text bar
            loadItems()
            
            // remove focus from search bar
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }

}
