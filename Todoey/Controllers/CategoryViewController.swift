//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jeremy Thompson on 2018-03-25.
//  Copyright © 2018 Jeremy Thompson. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    // initialize new realm
    let realm = try! Realm()
    
    // initialize categories
    //var categories = [Category]()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        // remove seperators between cells
        tableView.separatorStyle = .none
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if categories is nil return 1 instead
        return categories?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // call SwipeTableViewController super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = category.name
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            // Change cell's background color via chameleon framework
            cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
            // set font to contrast to bg
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        return cell
        
    }

    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // if click on table send to Items
        performSegue(withIdentifier: "goToItems", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        print("indexPathForSelectedRow\n")
        print(tableView.indexPathForSelectedRow)
        if let indexPath = sender as? IndexPath {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        // pull all categories
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        
        // to call methods from superclass
        super.updateModel(at: indexPath)
        // optional binding
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    print("item deleted")
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }

    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Using Category as NSManagedObject
            //let newCategory = Category(context: self.context)
            // Using Category as an Object (Realm)
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
}


