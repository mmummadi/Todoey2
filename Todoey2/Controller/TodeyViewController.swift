//
//  ViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/10/20.
//

import UIKit
//import Foundation


class TodeyViewController: UITableViewController {

   
    var todoeyArray = [Item]()
    
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var newItem = Item()
        newItem.title = "FirstTodoey"
        todoeyArray.append(newItem)
       
    }
    
    @IBAction func addTodoey(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
                
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let item = Item(title: textField.text!, done: false)
            self.todoeyArray.append(item)
            self.defaults.set(self.todoeyArray, forKey: "todoeyItem")
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)        
        
    }
    
  //MARK: - UITableViewDatasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoeyArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoeyCell", for: indexPath)
       
        let item = todoeyArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType =  item.done ?  .checkmark :  .none
        return cell
    }
   
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todoeyArray[indexPath.row].done = !todoeyArray[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

