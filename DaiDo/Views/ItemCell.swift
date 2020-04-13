//
//  ItemCell.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 12/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var itemCellBackground: UIView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemDone: UIImageView!
    @IBOutlet weak var itemPriority: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemCellBackground.layer.cornerRadius = 15
        itemPriority.layer.cornerRadius = 5
        itemPriority.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
