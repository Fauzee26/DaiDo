//
//  WalkthroughContentVC.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 10/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import Sejima

class WalkthroughContentVC: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var header: MUHeader!
  
    private var image: UIImage?
    private var headerTitle: String = ""
    private var headerDetail: String = ""
  
    override func viewDidLoad() {
        super.viewDidLoad()
        header.title = headerTitle
        header.detail = headerDetail
        imageView.image = image
        
        imageView.backgroundColor = .clear
        imageView.isOpaque = true
    }
  
    internal func setup(with image: UIImage, title: String, detail: String) {
        self.image = image
        headerTitle = title
        headerDetail = detail
    }
}
