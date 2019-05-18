//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm() // we can use ! because cannot fel
    
    // we type with Results
    var categoryArray : Results<Category>?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            //What will happen when Add Item button pressed
            if textField.text != "" {
                
                
                //we create item
                let newCategory = Category()
                newCategory.name = textField.text!
                
                
                self.save(category: newCategory)
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            // placeHolder is a grey text temporary appearing in textField
            alertTextField.placeholder = "create new Category"
            //use local var to get alerttextfield
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data manipulation Methods
    func save(category : Category) {
        //MARK: - Add with Realm
        do {
            try  realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    
    func loadCategories(){
       
        //MARK: -  get all object from realm Data base
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
}


extension CategoryViewController {
    
    //MARK: - TableView DataSource Methods
    //number of row In section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    //cell that will ne created with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no Categories added"
        
        return cell
        
    }
    
    
    
    //MARK: - TableView Delegate Methods
    // perform segue when we pressed cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //prepare segue before to perfomr it
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        //identify which cell have been pressed
        if  let indexPath = tableView.indexPathForSelectedRow {
            //we inform where we send data in other viewController
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
}
