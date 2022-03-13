//
//  MainTabBarViewController.swift
//  FakeBithumbAssignment
//
//  Created by chihoooon on 2022/03/08.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    // MARK: - Instance Property

    private var selectedTap: Int = 0

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.delegate = self
    }

    // MARK: - custom func

    private func configureUI() {
        self.tabBar.tintColor = .black
        self.tabBar.backgroundColor = .white
        self.configureTabBarShadow()
    }

    private func configureTabBarShadow() {
        self.tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.tabBar.layer.shadowRadius = 2
        self.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBar.layer.shadowOpacity = 0.3
    }

    private func scrollToTop(_ tableView: UITableView?, indexPath: IndexPath) {
        tableView?.scrollToRow(
            at: indexPath,
            at: .top,
            animated: true
        )
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarViewController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        let tabBarIndex: Int = tabBarController.selectedIndex
        let indexPath: IndexPath = IndexPath(row: NSNotFound, section: 0)
        let navigationViewController = viewController as? UINavigationController

        if tabBarIndex == 0 {
            self.selectedTap = 0
            let mainViewController = navigationViewController?.viewControllers[0] as? MainViewController
            self.scrollToTop(mainViewController?.totalCoinTableView.tableView, indexPath: indexPath)
            self.scrollToTop(mainViewController?.interestedCoinTableView.tableView, indexPath: indexPath)
        } else if tabBarIndex == 1 {
            if self.selectedTap == 1 {
                let depositAndWithdrawalViewController = navigationViewController?.viewControllers[0] as? DepositAndWithdrawalViewController
                self.scrollToTop(depositAndWithdrawalViewController?.tableView, indexPath: indexPath)
            }
            self.selectedTap = 1
        }
    }
}
