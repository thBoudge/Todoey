//
// TodoListViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-11.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "find John"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "eat fast"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "live long"
        itemArray.append(newItem3)
       
        //UserDefault
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }
        
    }

    @IBAction func addButtonItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when Add Item button pressed
            if textField.text != nil {
                
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                
                
                //save data in Userdefault
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
    
    
    //MARK - TABLEVIEW DATARESSOURCE METHODS
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
        cell.accessoryType = item.Done == true ? .checkmark : .none
        
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
        itemArray[indexPath.row].Done = !itemArray[indexPath.row].Done
        
        tableView.reloadData()
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

