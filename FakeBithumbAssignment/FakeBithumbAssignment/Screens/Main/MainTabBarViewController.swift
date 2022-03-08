//
//  MainTabBarViewController.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/08.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        self.tabBar.tintColor = .black
        self.tabBar.barTintColor = .red
        self.tabBarItem.badgeColor = .yellow
        self.tabBar.backgroundColor = .white
        configureTabBarShadow()
    }

    private func configureTabBarShadow() {
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
    }
}
