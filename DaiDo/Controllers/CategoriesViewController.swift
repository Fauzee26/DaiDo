//
//  NotesViewController.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 10/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoriesViewController: UIViewController {
    
    @IBOutlet weak var stackEmpty: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    
    let defaults = UserDefaults.standard
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(Realm.Configuration.defaultConfiguration.fileURL)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: K.categoryNibName, bundle: nil), forCellReuseIdentifier: K.categoryCell)
        tableView.rowHeight = 120.0
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let navBarColor = UIColor(hexString: K.Colors.orangeHeader) {
            setNavBarColors(with: navBarColor)
        }
        tableView.reloadData()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        if defaults.bool(forKey: "isFirstLaunch") != true {
            performSegue(withIdentifier: "goToLaunch", sender: self)
        }
    }
    
    private func emptyState() {
        if categories!.isEmpty {
            stackEmpty.isHidden = false
            tableView.isHidden = true
        } else {
            stackEmpty.isHidden = true
            tableView.isHidden = false
        }
    }
    
    @IBAction func addCategoriesClicked(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let actions = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text != "" {
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.colour = UIColor.randomFlat().hexValue()
                
                self.save(category: newCategory)
                self.emptyState()
            }
        }
        
        alert.addAction(actions)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulations Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error Saving Category: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
        emptyState()
    }
    
    //MARK: - Delete Data From Swipe
    func deleteCategories(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error Deleting Data: \(error)")
            }
        }
    }
    
    func confirmDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Category", message: "Are you sure you want to permanently delete '\(categories![indexPath.row].name)'?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteCategories(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .top)
            self.emptyState()
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension CategoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath) as! CategoriesCell
        if let category = categories?[indexPath.row] {
            cell.categoriesName.text = category.name
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.categoriesCellBackground.backgroundColor = categoryColour
            cell.categoriesName.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            cell.categoriesPercentage.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
            if category.items.count == 0 {
                cell.categoriesPercentage.text = "0/0"
            } else {
                let total = category.items.count
                var totalFinished = 0
                for i in category.items {
                    if i.done == true {
                        totalFinished += 1
                    }
                }
                
                cell.categoriesPercentage.text = "\(totalFinished)/\(total)"
                cell.categoriesCircular.progressClr = categoryColour.darken(byPercentage: 0.4)!
                cell.categoriesCircular.setProgressWithAnimation(duration: 1.0, value: Float(totalFinished)/Float(total))
            }
        }
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.goToItemSegue, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.goToItemSegue {
            let destinationVC = segue.destination as! ItemsViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDelete(indexPath: indexPath)
        } else if editingStyle == .insert {
            //            confirmDelete(indexPath: indexPath)
        }
    }
    
    func setNavBarColors(with color: UIColor) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("NavigationController does not exist yet")
        }
        let contrastColor = ContrastColorOf(color, returnFlat: true)
        
        // background
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = color
        
        // text
        navBar.tintColor = contrastColor
        navBarAppearance.titleTextAttributes = [.foregroundColor: contrastColor]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: contrastColor]
        
        // status bar
        navBar.standardAppearance = navBarAppearance
        navBar.scrollEdgeAppearance = navBarAppearance
    }
}
