//
// TodoListViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-11.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
   
    // Category? var is optional vecause is going to be nil until we use it
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    //we create criable context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //local adress of dataBase
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    @IBAction func addButtonItem(_ sender: UIBarButtonItem) {
        
       
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when Add Item button pressed
            if textField.text != "" {
                
                
                //we create item
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                //we specify this parent category
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                
                ///// method NSCoder \\\\\
                self.saveItems()
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
           // placeHolder is a grey text temporary appearing in textField
            alertTextField.placeholder = "create new item"
            //use local var to get alerttextfield
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
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
    //and with default value = NSPredicate? = nil
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        //filter itemArray with selectedCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //        // we create an array that have
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        


        
        do {
            //we load data in item array
        itemArray = try  context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
    //MARK: - TABLEVIEW DATARESSOURCE METHODS
        //number of row In section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
        //cell that will ne created with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        //Ternary operator can be read as :
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        }else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
        // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // add or not a chekmark when row selectec
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        //////Delete Row\\\\\\
//
//        //removing our data from our context store
//        context.delete(itemArray[indexPath.row])
//        //removing current item from Array
//        itemArray.remove(at: indexPath.row )
//        // we save context on CoreDatabase (persistant container)
        saveItems()
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

//MARK: - Extension SearchBARDelegate
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //nsPredicate
        //title CONTAINS %@ is a query langage from objective C
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // we want to sort response
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //we save data from our response request in ItemArray
       loadItems(with: request, predicate: predicate)

    }
    
    // How app's is going to react if we change text in research bar or if have ""
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
    
    
}

