//
//  CategoryViewCellTableViewController.swift
//  Todoey
//
//  Created by Ob yda on 6/8/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData



class CategoryViewController: SwipeTableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    var categoryArray = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        loadItems()
    }

    //MARK: - Add New Categories
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo List Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if textField.text != "" {
                
                
                let newItem = Category(context: self.context)
                newItem.name = textField.text!
                self.categoryArray.append(newItem)
                
                self.saveItems()
            }
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let listItem = categoryArray[indexPath.row]
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = listItem.name
        return cell
        
    }
    
    
    
    //MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveItems() {
            do{
            try context.save()
            } catch {
                print(error)
            }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    //Delete Data
    override func updateModel(at indexPath: IndexPath) {
        let index = self.categoryArray[indexPath.row]
        self.context.delete(index)
        self.categoryArray.remove(at: indexPath.row)
        try? self.context.save()
    }
    
}

