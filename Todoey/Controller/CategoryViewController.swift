//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-17.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()

 
    //we create criable context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category Name", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            //What will happen when Add Item button pressed
            if textField.text != "" {
                
                
                //we create item
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text
                self.categoryArray.append(newCategory)
                
                ///// method NSCoder \\\\\
                self.saveItems()
                
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
    // method ENCODE to save Item with NSCoder
    func saveItems() {
        
        //we save context on CoreDatabase (persistant container)
        do {
            try  context.save()
        }catch{
            print("Error saving context \(error)")
        }
        tableView.reloadData()
        
    }
    
    // method DECODE to Load Item with NSCoder
    //Method with default value = Item.fetchRequest()
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            //we load data in item array
            categoryArray = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}


extension CategoryViewController {
    
    //MARK: - TableView DataSource Methods
    //number of row In section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    //cell that will ne created with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
}
