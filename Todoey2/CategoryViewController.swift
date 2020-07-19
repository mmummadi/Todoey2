//
//  CategoryViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/17/20.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category1]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }

    // MARK: - Table view data source
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
         let item = categoryArray[indexPath.row]
         cell.textLabel?.text = item.name
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
           destinationVC.selectedCategory = categoryArray[indexpath.row]
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
            
            let item = Category1(context: self.context)
            item.name = textField.text!
            //item.done = false
            self.categoryArray.append(item)
            self.saveItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error saving items\(error)")
        }
        tableView.reloadData()
    }
    func loadItems(request : NSFetchRequest<Category1> = Category1.fetchRequest()) {
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
          categoryArray = try context.fetch(request)
        } catch {
            fatalError("Failed to fetch items: \(error)")
        }
        tableView.reloadData()
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
        let request : NSFetchRequest<Category1> = Category1.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchItem)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadItems(request : request)
        
    }
}
