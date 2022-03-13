//
//  MoreViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/11.
//

import UIKit

final class MoreViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    private let beansbin: MoreModel = MoreModel(characterImage: UIImage(named: "beansbin") ?? UIImage(),
                             name: "콩이(beansbin)",
                             mbti: "INTP",
                             github: "https://github.com/beansbin",
                             comment: "지식을 경험으로,\n그리고 경험을 공유로 이끌어나가는 개발자입니다.")
    private let chuuny: MoreModel = MoreModel(characterImage: UIImage(named: "choony") ?? UIImage(),
                             name: "추니(choony)",
                             mbti: "ISFP",
                             github: "https://github.com/kch1285",
                             comment: "계속해서 전진합니다.")
    private let momo: MoreModel = MoreModel(characterImage: UIImage(named: "momo") ?? UIImage(),
                             name: "모모(momo-youngg)",
                             mbti: "INFP",
                             github: "https://github.com/momo-youngg",
                             comment: "기똥차게 해냅니다.")
    private let beansbinView: MoreView = MoreView()
    private let chuunyView: MoreView = MoreView()
    private let momoView: MoreView = MoreView()
    private var stackView: UIStackView = UIStackView()
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patchData()
        self.configureViewForSize(view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.configureViewForSize(size)
    }
    
    override func configUI() {
        self.view.backgroundColor = .white
        self.configStackView()
        self.navigationItem.title = "짭썸 창시자들"
    }
    
    
    // MARK: - cusotm funcs
    
    private func configStackView() {
        self.stackView = UIStackView(arrangedSubviews: [
            self.beansbinView,
            self.chuunyView,
            self.momoView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
            $0.alignment = .center
        }
        
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func configureViewForSize(_ size: CGSize) {
      if size.width > size.height {
        stackView.axis = .horizontal
      } else {
        stackView.axis = .vertical
      }
    }
    
    private func patchData() {
        self.beansbinView.patchData(data: self.beansbin)
        self.chuunyView.patchData(data: self.chuuny)
        self.momoView.patchData(data: self.momo)
    }
}
