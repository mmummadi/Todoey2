//
//  ViewController.swift
//  Todoey2
//
//  Created by Anurag Guda on 7/10/20.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework



class TodeyViewController: SwipeTableViewController {

   
    var todoeyArray : Results<Item>?
    let realm = try! Realm()
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
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCategory?.color {
            title = selectedCategory?.name
            guard let navbar = navigationController?.navigationBar else { fatalError("navigationcontroller not established")}
            if let navbarColor = UIColor(hexString: colorHex){
                navbar.barTintColor = navbarColor
                navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
               navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
                searchBar.barTintColor = navbarColor
            }
            
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(hexString : "34C759")
    }
    
    @IBAction func addTodoey(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Todoey Item", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            textField = alertTextField
        }
                
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.date = Date()
                        
                             currentCategory.items.append(item)
                    }
                }catch {
                    print("error saving items")
            }
                    
        }
            self.tableView.reloadData()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)        
        
    }
    
    
    func loadItems() {
        todoeyArray = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
                         
       tableView.reloadData()
    }
    
  //MARK: - UITableViewDatasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoeyArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let bgcolor = selectedCategory?.color {
            cell.backgroundColor = UIColor(hexString: bgcolor)?.darken(byPercentage: CGFloat(Double(indexPath.row)*0.1))
        }
        
        cell.textLabel?.text = todoeyArray?[indexPath.row].title ?? "No items added yet"
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        cell.accessoryType =  todoeyArray?[indexPath.row].done ?? false ?  .checkmark :  .none
        return cell
    }
   
    
    //MARK: - UITableViewDelegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        do {
            try realm.write {
              todoeyArray![indexPath.row].done = !todoeyArray![indexPath.row].done
            }
        }catch {
            print("error while updating")
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write {
                self.realm.delete(self.todoeyArray![indexPath.row])
                
          }
        }catch {
            print("error deleting item")
        }
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
        todoeyArray = todoeyArray?.filter("title CONTAINS[cd] %@", searchItem).sorted(byKeyPath: "title", ascending: true)

        
    }
    
    
}

