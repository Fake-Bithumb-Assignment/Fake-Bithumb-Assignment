//
//  CoinPagingViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/26.
//

import UIKit

final class CoinPagingViewController: UIPageViewController {
    
    // MARK: - Instance Property
    
    private var pages: [UIViewController]?
    
    
    // MARK: - Life Cycle func
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(pages : [UIViewController]) {
        self.pages = pages
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegations()
        configUI()
    }
    
    
    // MARK: - custom funcs
    
    private func configUI() {
        if let pages = pages {
            setViewControllers([pages[0]], direction: .forward, animated: false, completion: nil)
        }
    }
    
    private func setDelegations() {
        dataSource = nil
        delegate = nil
    }
}


// MARK: - PagingViewController Extensions

extension CoinPagingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pages = pages else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard pages.count > previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pages = pages else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else { return nil }
        guard pages.count > nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}

extension CoinPagingViewController: UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        guard let pages = pages else {
            return 0
        }
        
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first else {
            return 0
        }
        
        guard let pages = pages, let firstViewControllerIndex = pages.firstIndex(of: firstViewController) else {
            return 0
        }
        
        return firstViewControllerIndex
    }
}
