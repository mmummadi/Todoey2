//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/17/20.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
   
    var categoryArray : Results<Category1>?
    @IBOutlet weak var searchBar: UISearchBar!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
        
    }

    // MARK: - Table view data source
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let bgcolor = categoryArray?[indexPath.row].color {
          cell.backgroundColor = UIColor(hexString: bgcolor)
        }
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories"
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        // cell.accessoryType =  item.done ?  .checkmark :  .none
         return cell
    }
    
    //MARK: - TableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodeyViewController
        if let indexpath = tableView.indexPathForSelectedRow {
           destinationVC.selectedCategory = categoryArray?[indexpath.row]
        }
        
    }
    
    // MARK: - Adding new Categories
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
                
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Category1()
            item.name = textField.text!
            item.color = UIColor.randomFlat().hexValue()
            self.saveItems(item : item)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveItems(item : Category1){
        
        do{
            try realm.write {
                realm.add(item)
            }
        }catch {
            print("error saving items")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
    
        categoryArray = realm.objects(Category1.self)
                          
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                self.realm.delete(self.categoryArray![indexPath.row])
                
          }
        }catch {
            print("error deleting item")
        }
    }
    
}

extension CategoryViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
           
        }
        
    }
       
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchItem = searchBar.text!
        categoryArray = categoryArray?.filter("name CONTAINS[cd] %@", searchItem).sorted(byKeyPath: "name", ascending: true)
        
    }
}
