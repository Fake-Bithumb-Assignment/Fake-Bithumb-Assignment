//
//  MoreViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/11.
//

import UIKit

final class MoreViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    let beansbin = MoreModel(characterImage: UIImage(named: "beansbin") ?? UIImage(),
                             name: "콩이(beansbin)",
                             mbti: "INTP",
                             github: "https://github.com/beansbin",
                             comment: "지식을 경험으로,\n그리고 경험을 공유로 이끌어나가는 개발자입니다.")
    
    let choony = MoreModel(characterImage: UIImage(named: "choony") ?? UIImage(),
                             name: "추니(choony)",
                             mbti: "ISFP",
                             github: "https://github.com/kch1285",
                             comment: "안녕하세요")
    
    let momo = MoreModel(characterImage: UIImage(named: "momo") ?? UIImage(),
                             name: "모모(momo-youngg)",
                             mbti: "INFP",
                             github: "https://github.com/momo-youngg",
                             comment: "안녕하세요")
    
    let beansbinView = MoreView()
    let choonyView = MoreView()
    let momoView = MoreView()
    var stackView = UIStackView()
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.patchData()
        self.configureViewForSize(view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)
      configureViewForSize(size)
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
            self.choonyView,
            self.momoView
        ]).then {
            $0.axis = .vertical
            $0.spacing = 10
            $0.distribution = .fillEqually
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
        self.choonyView.patchData(data: self.choony)
        self.momoView.patchData(data: self.momo)
    }
}
