//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 10/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var todoeyItems:[String] = []
    
    let defaults:UserDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let values = defaults.value(forKey: "todoeyItems") {
            self.todoeyItems = values as! [String]
        }
    }
    
    //MARK: - Add new Todoey item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        
        /* variavel do tipo textfield que guardará o item digitado pelo usuário */
        var textField:UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add novo Todoey", message: "", preferredStyle: .alert)
        
        /* codigo que executa ao clicar no botao salvar */
        let actionSave = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if(textField.text!.count > 0){
                
                self.todoeyItems.append(textField.text!)
                
                self.defaults.set(self.todoeyItems, forKey: "todoeyItems")
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
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
         
        cell.textLabel?.text = todoeyItems[indexPath.row]
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Show alert with textfield
    func showAlert(){
        
    }
    
}

