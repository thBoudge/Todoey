//
// TodoListViewController.swift
//  Todoey
//
//  Created by Thomas Bouges on 2019-04-11.
//  Copyright © 2019 Thomas Bouges. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["find jhon","buy eggs","eat eggs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    
    //MARK - TABLEVIEW DATARESSOURCE METHODS
        //number of row In section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
        //cell that will ne created with text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView Delegate Methods
    
        // everytime we select a cell what do we do
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // add or not a chekmark when row selectec
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        print(indexPath.row)
        
        //we change selection row brilliance t a fast one
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

