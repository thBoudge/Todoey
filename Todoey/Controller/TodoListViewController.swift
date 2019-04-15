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
    // Create a file path to the Documents folder.
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
        
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
        
        /////NS Coder\\\\\
        // document We create an encoder
        let encoder = PropertyListEncoder()
        // we create an array
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding an array")
        }
        
        tableView.reloadData()
        
    }
    
    // method DECODE to Load Item with NSCoder
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error when decode data \(error)")
            }
        }
        tableView.reloadData()
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
        
        saveItems()
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

