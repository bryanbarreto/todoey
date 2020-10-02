//
//  ViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 10/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoeyItems:Results<Item>?
    var selectedCategory:Category? {
        didSet {
            self.loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let color = selectedCategory?.color {
            
            
            self.navigationController?.navigationBar.backgroundColor = UIColor(hexString: color)
           
            //muda a cor do botao na navbar
            self.navigationController?.navigationBar.tintColor = ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)
            
            //muda background da searchbar
            searchBar.barTintColor = UIColor(hexString: color)
            
            //muda a cor do titulo da navbar
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(UIColor(hexString: color)!, returnFlat: true)]
            
        }
        
        title = self.selectedCategory!.name
        
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
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.createdAt = Date()
                            currentCategory.items.append(newItem)
                        }
                    }catch{
                        print("error: \(error)")
                    }
                }
            }
            self.tableView.reloadData()
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
        return self.todoeyItems?.count ?? 1
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.todoeyItems?[indexPath.row] {
            do{
                try self.realm.write {
                    realm.delete(item)
                }
            }catch{
                print("error deleting item line 85: \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoeyItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
            let percentage = Double(indexPath.row) / Double(self.todoeyItems!.count)
            let color = self.selectedCategory?.color
            cell.backgroundColor = UIColor(hexString: color!)?.darken(byPercentage: CGFloat(percentage))
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        }else {
            cell.textLabel?.text = "Nenhum Todoey cadastrado"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoeyItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error line 105: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - Model Manipulating
    
    
    /*
     funcao para carregar os itens do banco de dados
     cria uma variavel request que recebe um fetchrequest do tipo Items (modelo)
     depois chama o fetch do contexto passando a variavel request
     */
    func loadItems(){
        
        self.todoeyItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }
}


//MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
//
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.endEditing(true)

        self.todoeyItems = self.todoeyItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdAt", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {

            self.loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
