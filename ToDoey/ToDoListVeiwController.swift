//
//  ViewController.swift
//  ToDoey
//
//  Created by Артур Мусин on 17/09/2019.
//  Copyright © 2019 working. All rights reserved.
//

import UIKit

class ToDoListVeiwController: UITableViewController {
    

    
    var itemArray = [Item]()
    //создаем путь для сохранения файлов
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //создаем UserDefaults для сохранения данных. UserDefaults используется для сохранения необольшого объема данных. При использовании как базу данных может повлиять на работоспособность и скорость приложения. UserDefaults - singleton Object
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
       
        
       // print(datafilePath)
        
        
        
//        //загружаем массив из UserDefaults
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        loadItems()
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
            
            let newItem = Item()
            newItem.title = textField.text!
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            //сохраняем инфу по нашему пути
            try data.write(to: self.datafilePath!)
        } catch {
            print("error encoding item array, \(error)")
        }
          self.tableView.reloadData()
    }
    
    //функция для загрузки plist
    func loadItems() {
       if let data = try? Data(contentsOf: datafilePath!) {
            let decoder = PropertyListDecoder()
        do {
        itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding \(error)")
        }
    }
    }
    
}


