//
// TodoListViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-11.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems : Results<Item>?
    let realm = try! Realm()
   
    // Category? var is optional vecause is going to be nil until we use it
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func addButtonItem(_ sender: UIBarButtonItem) {
        
       
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when Add Item button pressed
            if textField.text != "" {
                
                if let currentCategory = self.selectedCategory{
                    
                    do {
                        try  self.realm.write {
                            //MARK: - Create item in Realm
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            //we specify this parent category but used other way
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("Error saving context \(error)")
                    }
                }
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

    
    
    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - TABLEVIEW DATARESSOURCE METHODS
        //number of row In section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
        //cell that will ne created with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if  let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
       
        //Ternary operator
        // value = condition ? valueIftrue : valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            
            cell.textLabel?.text = "No items added"
        }
       
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
        // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try? realm.write {
                    //MARK: - delete Real Database
//                    realm.delete(item)
                    //MARK: - Update Real Database
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, /(error)")
            }
            
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

//MARK: - Extension SearchBARDelegate
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //MARK: - Query and Sort with Realm
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

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

