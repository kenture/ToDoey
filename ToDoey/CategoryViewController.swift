//
//  CategoryViewController.swift
//  ToDoey
//
//  Created by Артур Мусин on 30.09.2019.
//  Copyright © 2019 working. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
       
    }

     //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
     //MARK: - Data Manipulation Methods
    
    func saveCategories() {
            
            do {
                try context.save()
            } catch {
               print("Error saving context \(error)")
            }
              self.tableView.reloadData()
        }
        
    //    //функция для загрузки plist
        func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
         
            do {
              categories = try context.fetch(request)
            } catch {
                print("error fetching data from context \(error)")
            }
            tableView.reloadData()
        }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               
               //  создаем UIALertController
               let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
               //создаем действие для UIALertController
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   //Что будет если юзер нажмет на кнопку
                   
                   
                   let newCategory = Category(context: self.context)
                   newCategory.name = textField.text!
                   
                   self.categories.append(newCategory)
                   
                   //сохраняем массив в userdefaults
                   //self.defaults.set(self.itemArray, forKey: "TodoListArray")
                   
                   self.saveCategories()
                 
               }
               
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "Create New Category"
                   textField = alertTextField
               }
               
               alert.addAction(action)
               
               present(alert, animated: true, completion: nil)
    }
    
   
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListVeiwController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
}
