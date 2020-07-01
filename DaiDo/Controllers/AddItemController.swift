//
//  AddItemController.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 13/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import RealmSwift

class AddItemController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var pickerPriority: UIPickerView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var toolbar: UINavigationBar!
    @IBOutlet weak var alarmSwitch: UISwitch!
    @IBOutlet weak var alarmPicker: UIDatePicker!
    
    var delegate: ItemsDelegate?
    
    var choices = ["Low", "Medium", "High"]
    var selectedChoices = String()
    
    var items: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category?
    var isAlarm = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.delegate = self
        btnAdd.layer.cornerRadius = 10
        pickerPriority.delegate = self
        btnAdd.backgroundColor = UIColor(hexString: selectedCategory!.colour)?.lighten(byPercentage: 0.5)
        toolbar.barTintColor = UIColor(hexString: selectedCategory!.colour)?.lighten(byPercentage: 0.3)
        //        view.backgroundColor = UIColor(hexString: selectedCategory!.colour)?.lighten(byPercentage: 0.4)
        
        alarmPicker.datePickerMode = .time
        titleTextField.becomeFirstResponder()
    }
    
    @IBAction func timePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()

        dateFormatter.timeStyle = DateFormatter.Style.short

        let strDate = dateFormatter.string(from: alarmPicker.date)
    }
    
    @IBAction func addAlarmSwitched(_ sender: UISwitch) {
        let onState = alarmSwitch.isOn
        
        isAlarm = onState
        alarmPicker.isHidden = !isAlarm
    }
    
    
    @IBAction func addItemPressed(_ sender: UIButton) {
        if titleTextField.text != "" {
            if let itemName = titleTextField.text {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = itemName
                            newItem.dateCreated = Date()
                            newItem.priority = selectedChoices
                            currentCategory.items.append(newItem)
                            
                            self.dismiss(animated: true, completion: nil)
                            guard let parent = storyboard? .instantiateViewController (withIdentifier: "ItemsViewController") as? ItemsViewController else {
                                fatalError ()
                            }
                            parent.refresh ()
                            delegate?.itemAdded()
                        }
                    } catch {
                        print("Error saving new items: \(error)")
                    }
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    //MARK: - Pickerview Delegate and Datasource
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
        selectedChoices = choices[row]
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
