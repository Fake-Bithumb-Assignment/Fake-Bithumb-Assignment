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
        self.delegate = self
    }

    private func configureUI() {
        self.tabBar.tintColor = .black
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

// MARK: - UITabBarControllerDelegate

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            let navigationViewController = viewController as? UINavigationController
            let mainViewController = navigationViewController?.viewControllers[0] as? MainViewController

            mainViewController?.totalCoinListView.totalCoinListTableView.scrollToRow(
                at: indexPath,
                at: .top,
                animated: true
            )

            mainViewController?.interestedCoinListView.interestedCoinListTableView.scrollToRow(
                at: indexPath as IndexPath,
                at: .top,
                animated: true
            )
        }
    }
}
