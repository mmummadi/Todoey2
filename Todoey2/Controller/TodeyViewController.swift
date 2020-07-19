//
//  ViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/10/20.
//

import UIKit
import CoreData


class TodeyViewController: UITableViewController {

   
    var todoeyArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory : Category1? {
        didSet{
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
    }       
    
    @IBAction func addTodoey(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
                
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            item.parent = self.selectedCategory
            self.todoeyArray.append(item)
            self.saveItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)        
        
    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error saving items\(error)")
        }
        tableView.reloadData()
    }
    func loadItems(request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil) {
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
       let request : NSFetchRequest<Item> = Item.fetchRequest()
       let predicate2 = NSPredicate(format: "parent.name MATCHES %@", selectedCategory!.name!)
        if let queryPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate2,queryPredicate])
            request.predicate = compoundPredicate
        }else {
            request.predicate = predicate2
        }
        
        
        do {
          todoeyArray = try context.fetch(request)
        } catch {
            fatalError("Failed to fetch items: \(error)")
        }
        tableView.reloadData()
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
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TodeyViewController : UISearchBarDelegate {
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
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchItem)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request : request,predicate: predicate)
        
    }
}
