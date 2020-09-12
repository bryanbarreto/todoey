//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 10/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoeyItems:[Item] = []
    
    let defaults:UserDefaults = UserDefaults()
    
    let dataFilePath:URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        if let values = defaults.array(forKey: Constants.userDefaultsKey) {
            self.todoeyItems = values as! [Item]
        }
        
        self.loadItems()
    }
    
    //MARK: - Add new Todoey item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        
        /* variavel do tipo textfield que guardará o item digitado pelo usuário */
        var textField:UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add novo Todoey", message: "", preferredStyle: .alert)
        
        /* codigo que executa ao clicar no botao salvar */
        let actionSave = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if(textField.text!.count > 0){
                
                let newItem:Item = Item(task: textField.text!, isDone: false)
                
                self.todoeyItems.append(newItem)
                
                self.saveItems()
                
            }
        }
        
        /* codigo que sera executado ao clicar no botao cancelar*/
        let actionCancel = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
        
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionSave)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Faça algo incrível..."
            
            /* atribui o alertTextField(escopo local) para textField(escopo global) */
            textField = alertTextField
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoeyItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reusableCell, for: indexPath)
        
        let item = todoeyItems[indexPath.row]
         
        cell.textLabel?.text = item.task
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoeyItems[indexPath.row].isDone = !todoeyItems[indexPath.row].isDone
        
        self.saveItems()
        
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Model Manipulating
    func saveItems(){
        
        let encoder: PropertyListEncoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.todoeyItems)
            try data.write(to: self.dataFilePath!)
        }catch {
            print("Erro: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: self.dataFilePath!){
            let decoder:PropertyListDecoder = PropertyListDecoder()
            do{
                todoeyItems = try decoder.decode([Item].self, from: data)
            }catch{
                print("Erro: \(error)")
            }
        }
    }
    
}

