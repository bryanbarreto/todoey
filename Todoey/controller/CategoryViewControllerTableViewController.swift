//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Bryan Barreto on 13/09/20.
//  Copyright © 2020 Bryan Barreto. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewControllerTableViewController: UITableViewController {
    
    var categories:[Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.loadCategories()
        
    }
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textField:UITextField = UITextField()
        
        let alert:UIAlertController = UIAlertController(title: "Nova Categoria", message: "", preferredStyle: .alert)
        
        let saveAction:UIAlertAction = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if textField.text!.count > 0 {
                
                let newCategory:Category = Category(context: self.context)
                newCategory.name = textField.text
                
                self.categories.append(newCategory)
                
                self.saveCategories()
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
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.categoryCell, for: indexPath)
        
        
        cell.textLabel?.text = self.categories[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Table View delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = self.categories[indexPath.row]
        }
    }
    
    //MARK: - Data Model manipulation
    func saveCategories(){
        do {
            try self.context.save()
            self.tableView.reloadData()
            
        } catch {
            print("error save categories: \(error)")
        }
    }
    
    func loadCategories(with request:NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            
            self.categories = try self.context.fetch(request)
            self.tableView.reloadData()
            
        } catch {
            print("error loading categories: \(error)")
        }
    }
    
}
