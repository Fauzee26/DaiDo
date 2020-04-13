//
//  CategoriesCell.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 12/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit

class CategoriesCell: UITableViewCell{
    @IBOutlet weak var categoriesName: UILabel!
    @IBOutlet weak var categoriesCircular: CircularProgressView!
    @IBOutlet weak var categoriesPercentage: UILabel!
    @IBOutlet weak var categoriesCellBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()

        categoriesCircular.trackClr = UIColor.lightGray
//        categoriesCircular.progressClr = UIColor.purple
        categoriesCellBackground.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
