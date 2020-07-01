//
//  ItemsViewController.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 12/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

protocol ItemsDelegate {
    func itemAdded()
}

class ItemsViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, ItemsDelegate {
    
    var choices = ["Low","Medium","High"]
    var pickerView = UIPickerView()
    var selectedChoices = String()
    
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    func refresh() {
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.itemNibName, bundle: nil), forCellReuseIdentifier: K.itemCell)
        tableView.rowHeight = 100.0
        
        self.itemAdded()
        tableView.reloadData()
    }
    
    func itemAdded() {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        
        self.itemAdded()
        if let colorHex = selectedCategory?.colour, let navBarColor = UIColor(hexString: colorHex) {
            setNavBarColors(with: navBarColor)
        }
        
    }
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error Deleting Item: \(error)")
            }
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
    
    //MARK: - Pickerview Datasource and Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return choices[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            selectedChoices = "Low"
        } else if row == 1 {
            selectedChoices = "Medium"
        } else if row == 2 {
            selectedChoices = "High"
        }
    }
    
    //MARK: - Tableview Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if items?.count == 0 {
            self.tableView.setEmptyState()
        } else {
            self.tableView.restore()
        }
        
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.itemCell, for: indexPath) as! ItemCell
        
        if let item = items?[indexPath.row] {
            cell.itemName.text = item.title
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage:
                CGFloat(indexPath.row) / CGFloat(items!.count)
                ) {
                cell.itemCellBackground.backgroundColor = colour
                cell.itemName.textColor = ContrastColorOf(colour, returnFlat: true)
                cell.itemDone.tintColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            switch item.priority {
            case "Low":
                cell.itemPriority.text = "Low"
                cell.itemPriority.backgroundColor = UIColor(hexString: K.Colors.hexLow)
            case "Medium":
                cell.itemPriority.text = "Medium"
                cell.itemPriority.backgroundColor = UIColor(hexString: K.Colors.hexMedium)
            case "High":
                cell.itemPriority.text = "High"
                cell.itemPriority.backgroundColor = UIColor(hexString: K.Colors.hexHigh)
            default:
                cell.itemPriority.text = "Low"
                cell.itemPriority.backgroundColor = UIColor(hexString: K.Colors.hexLow)
            }
            
            cell.itemDone.isHidden = item.done ? false : true
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        
        return cell
    }
    
    //MARK: - Tableview Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            confirmDelete(indexPath: indexPath)
        } else if editingStyle == .insert {
            //            confirmDelete(indexPath: indexPath)
        }
    }
    
    func confirmDelete(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to permanently delete '\(items![indexPath.row].title)'?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.deleteItem(at: indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .top)
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Add New Item
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: K.addItemSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.addItemSegue {
            let destinationVC = segue.destination as! AddItemController
            destinationVC.delegate = self
            destinationVC.selectedCategory = selectedCategory
        }
    }
}
