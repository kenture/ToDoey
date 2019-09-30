//
//  ViewController.swift
//  ToDoey
//
//  Created by Артур Мусин on 17/09/2019.
//  Copyright © 2019 working. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVeiwController: UITableViewController{
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    //создаем путь для сохранения файлов
    //let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //создаем UserDefaults для сохранения данных. UserDefaults используется для сохранения необольшого объема данных. При использовании как базу данных может повлиять на работоспособность и скорость приложения. UserDefaults - singleton Object
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        
       // print(datafilePath)
        
        
        
//        //загружаем массив из UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
   
    }
    
    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueifTrue : valueIfFalse
         //добавляем и убираем галочку при нажатии
        cell.accessoryType = item.done ? .checkmark : .none
        /*
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        */
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        
        //убирает выделение ячейки при выборе
        tableView.deselectRow(at: indexPath, animated: true)
        
        //  меняем свойство done для установки галочки
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //удаляем по тапу
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        tableView.reloadData()
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //  создаем UIALertController
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        //создаем действие для UIALertController
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //Что будет если юзер нажмет на кнопку
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //сохраняем массив в userdefaults
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
          
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
           print("Error saving context \(error)")
        }
          self.tableView.reloadData()
    }
    
//    //функция для загрузки plist
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
     
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        

        
        do {
          itemArray = try context.fetch(request)
        } catch {
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

    
}

extension ToDoListVeiwController: UISearchBarDelegate {
    
    //метод для поиска
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request, predicate: predicate)
        

    }
       //загрузка всего контента когда в сечбаре нету символов
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //снимает курсор из сечбара
            DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
           
        }
    }
    
}
