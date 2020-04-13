//
//  Utils.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 12/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import ChameleonFramework

class Utils: UIViewController {
    
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
