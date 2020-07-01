//
//  Constant.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 12/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

struct K {
    static let categoryCell = "CategoryCell"
    static let categoryNibName = "CategoriesCell"
    static let goToItemSegue = "goToItems"
    static let itemCell = "ItemCell"
    static let itemNibName = "ItemCell"
    static let addItemSegue = "addNewItem"
    
    struct Colors {
        static let orangeHeader = "#FF5722"
        
        static let hexHigh = "#FF5C00"
        static let hexMedium = "#F4FF00"
        static let hexLow = "#00FF15"
    }
}

extension UITableView {
    func setEmptyState() {
        let label1 = UILabel()
        label1.textAlignment = .center
        label1.numberOfLines = 0
        
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "AvenirNext-DemiBold", size: 24)]
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Medium", size: 20)]
        
        let attributedString1 = NSMutableAttributedString(string:"No Todo Available :(", attributes:attrs1 as [NSAttributedString.Key : Any])
        let attributedString2 = NSMutableAttributedString(string:"\nPress + to add new todo", attributes:attrs2 as [NSAttributedString.Key : Any])
        
        attributedString1.append(attributedString2)
        label1.attributedText = attributedString1
        
        let stackEmpty = UIStackView(frame: CGRect(x: self.bounds.size.width, y: self.bounds.size.height, width: self.bounds.size.width, height: 65.0))
        stackEmpty.axis = .vertical
        stackEmpty.alignment = .fill
        stackEmpty.distribution = .fill
        stackEmpty.spacing = 0.0
        stackEmpty.backgroundColor = .cyan
        
        stackEmpty.addArrangedSubview(label1)
        
        self.backgroundView = stackEmpty
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
