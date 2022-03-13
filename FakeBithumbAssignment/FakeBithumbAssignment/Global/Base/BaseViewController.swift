//
//  BaseViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render()
        configUI()
        setNavigationGesture()
    }
    
    func render() {
        // 레이아웃 구성 (ex. addSubView, autolayout 코드)
    }
    
    func configUI() {
        // 뷰 configuration (ex. view 색깔, 네비게이션바 설정 ..)
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setBaseNavigationBar(isTranslucent: Bool = false,
                              backgroundColor: UIColor = .white,
                              titleColor: UIColor = .black,
                              tintColor: UIColor = .black) {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()

        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = .clear
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = isTranslucent
        navigationBar.tintColor = tintColor
    }
    
    private func setNavigationGesture() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

}
