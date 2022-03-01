//
//  CoinPagingViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

import SnapKit
import Then

enum TabView {
    case quote, graph, contractDetails
}

final class CoinPagingViewController: UIPageViewController {
    
    // MARK: - Instance Property
    private var pages : [UIViewController]?
    
    // MARK: - Life Cycle func
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeTabViewController()
        self.setFirstShowViewController()
    }
    
    
    // MARK: - custom funcs
    
    private func makeTabViewController() {
        self.pages = [CoinQuoteInformationTabViewController(), CoinGraphTabViewController(), CoinContractDetailsTabViewController()]
    }
    
    private func setFirstShowViewController() {
        self.setTabViewController(to: .quote)
    }
    
    func setTabViewController(to type: TabView) {
        guard let pages = self.pages else { return }
        switch type {
        case .quote:
            self.setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        case .graph:
            self.setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
        case .contractDetails:
            self.setViewControllers([pages[2]], direction: .forward, animated: false, completion: nil)
        }
    }
}

