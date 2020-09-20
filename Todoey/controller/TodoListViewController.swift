//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 10/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var todoeyItems:[Item] = []
    var selectedCategory:Category? {
        didSet {
            self.loadItems()
            print("didSet Method")
        }
    }
    
    /* contexto utilizado para persistir os dados no database do celular */
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Add new Todoey item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        
        /* variavel do tipo textfield que guardará o item digitado pelo usuário */
        var textField:UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add novo Todoey", message: "", preferredStyle: .alert)
        
        /* codigo que executa ao clicar no botao salvar */
        /*
            cria uma variavel newItem d tipo Item (classe modelo vinculada ao database sqlite)
            depois popula os atributos do modelo e chama o metodo de salvar
        */
        let actionSave = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if(textField.text!.count > 0){
                
                let newItem:Item = Item(context: self.context)
                newItem.title = textField.text
                newItem.parentCategory = self.selectedCategory
                newItem.done = false
                
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
         
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoeyItems[indexPath.row].done = !todoeyItems[indexPath.row].done
        
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Model Manipulating
    
    /* funcao para salvar itens. Pega o contexto e chama o metodo save */
    func saveItems(){

        do {
            try self.context.save()
        }catch {
            print("Erro saveItems: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    /*
        funcao para carregar os itens do banco de dados
        cria uma variavel request que recebe um fetchrequest do tipo Items (modelo)
        depois chama o fetch do contexto passando a variavel request
     */
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), and predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let aditionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, aditionalPredicate])
        }else {
            request.predicate = categoryPredicate
        }
 
        
        do{
            self.todoeyItems = try self.context.fetch(request)
        }catch{
            print("erro load items: \(error)")
        }
        
        self.tableView.reloadData()
    }
}


//MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        if searchBar.text?.count ?? 0 > 0 {
            let request:NSFetchRequest<Item> = Item.fetchRequest()
            
            /* realiza uma busca onde o titulo contenha o texto pesquisado*/
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            /* ordena os dados pelo titulo */
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            //request.predicate = predicate
            request.sortDescriptors = [sortDescriptor]
            
            self.loadItems(with: request, and: predicate)
            
        }
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            self.loadItems()
            
        }
    }
    
}
