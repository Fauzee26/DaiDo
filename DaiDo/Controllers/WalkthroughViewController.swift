//
//  ViewController.swift
//  DaiDo
//
//  Created by Muhammad Hilmy Fauzi on 10/04/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import UIKit
import Sejima

class WalkthroughViewController: UIViewController {
    
    @IBOutlet weak var horizontalPager: MUHorizontalPager!
    @IBOutlet weak var pageControl: MUPageControl!
    @IBOutlet weak var button: MUButton!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                // Else scroll view will be visible on page animation
        view.clipsToBounds = true
                
        addScrollViews()
        horizontalPager.delegate = self
        horizontalPager.pageControl = pageControl
        button.delegate = self
        button.buttonBackgroundColor = .clear
        
    }
    
    private func addScrollViews() {
        let vcs = [
            contentView(with: #imageLiteral(resourceName: "notepad"), title: "Daily Todo", detail: "Set Your Daily Todo Right Away!")?.view ?? UIView(),
            contentView(with: #imageLiteral(resourceName: "alert"), title: "Prioritise The One", detail: "Set Your Prioritise for Each Task!")?.view ?? UIView(),
            contentView(with: #imageLiteral(resourceName: "bell"), title: "Private Alarm", detail: "Schedule Task's Alarm To Boost Your Productivity!")?.view ?? UIView()
        ]
        horizontalPager.add(views: vcs, margin: horizontalPager.horizontalMargin)
    }
    
    private func contentView(with image: UIImage, title: String = "", detail: String = "") -> WalkthroughContentVC? {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WalkthroughView") as? WalkthroughContentVC else { return nil }
        vc.setup(with: image, title: title, detail: detail)
        return vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNotes" {
            UserDefaults.standard.set(true, forKey: "isFirst")
        }
    }
}

extension WalkthroughViewController: MUHorizontalPagerDelegate {
    func didScroll(_ horizontalPager: MUHorizontalPager, to index: Int) {
        guard let numberOfPages = horizontalPager.pageControl?.numberOfPages else { return }
        button.title = numberOfPages - 1 == index ? "LET'S GO" : "SKIP"
    }
}

extension WalkthroughViewController: MUButtonDelegate {
    func didTap(_ button: MUButton) {
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
        navigationController?.popViewController(animated: false)
    }
}
