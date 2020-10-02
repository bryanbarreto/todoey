//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 13/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewControllerTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadCategories()
        
        self.tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.backgroundColor = UIColor.systemBlue
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField:UITextField = UITextField()
        
        let alert:UIAlertController = UIAlertController(title: "Nova Categoria", message: "", preferredStyle: .alert)
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if textField.text!.count > 0 {
                
                let newCategory:Category = Category()
                newCategory.name = textField.text!
                newCategory.color = UIColor.randomFlat().hexValue()
                
                self.save(category: newCategory)
            }
        }
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancelar", style: .destructive) { (action) in
            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Lista de Compras"
            
            textField = alertTextField
        }
        
        self.present(alert, animated: true) {
            
        }
        
    }
    
    //MARK: - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = self.categories?[indexPath.row].name ?? "Nenhuma Categoria Salva"
        let color = self.categories?[indexPath.row].color
        cell.backgroundColor = UIColor(hexString: color!)
        
         cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = self.categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Model manipulation
    func save(category:Category){
        do {
            try self.realm.write {
                realm.add(category)
            }
            self.tableView.reloadData()
            
        } catch {
            print("error save categories: \(error)")
        }
    }
    
    func loadCategories(){
        self.categories = self.realm.objects(Category.self)
        
    }
    
    //MARK: - deleting data
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch{
                print("error deleting category line 105: \(error)")
            }
        }
    }
    
}
