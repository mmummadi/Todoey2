//
//  ViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/10/20.
//

import UIKit
//import Foundation


class TodeyViewController: UITableViewController {

   
    var todoeyArray : [String] = []
    
    var defaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let itemsArray = defaults.array(forKey: "todoeyItem") as? [String] {
        todoeyArray = itemsArray
        }
       
    }
    
    @IBAction func addTodoey(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
                
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.todoeyArray.append(textField.text!)
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
       
           cell.textLabel?.text = todoeyArray[indexPath.row]
             
        return cell
    }
   
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .none {
                 cell.accessoryType = .checkmark
                 tableView.deselectRow(at: indexPath, animated: true)
            }else {
                 cell.accessoryType = .none
                 tableView.deselectRow(at: indexPath, animated: true)
            }

        }
    }
}

