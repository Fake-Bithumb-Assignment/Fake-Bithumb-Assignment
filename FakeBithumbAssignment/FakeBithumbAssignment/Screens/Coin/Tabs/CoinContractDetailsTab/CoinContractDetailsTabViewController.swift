//
//  CoinContractDetailsTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

final class CoinContractDetailsTabViewController: BaseViewController {
    
    // MARK: - Instance Property
    private let timeTableView = UITableView().then {
        $0.register(ContractTimeTableViewCell.self,
                    forCellReuseIdentifier: ContractTimeTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let priceTableView = UITableView().then {
        $0.register(ContractPriceAndVolumeTableViewCell.self,
                    forCellReuseIdentifier: ContractPriceAndVolumeTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let volumeTableView = UITableView().then {
        $0.register(ContractPriceAndVolumeTableViewCell.self,
                    forCellReuseIdentifier: ContractPriceAndVolumeTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
    }
    
    override func render() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configUI() {
        configStackView()
        configTableView()
    }
    
    
    // MARK: - custom funcs
    
    func setDelegates() {
        self.timeTableView.dataSource = self
        self.timeTableView.delegate = self
        self.priceTableView.dataSource = self
        self.priceTableView.delegate = self
        self.volumeTableView.dataSource = self
        self.volumeTableView.delegate = self
        
        self.timeTableView.isUserInteractionEnabled = false
        self.priceTableView.isUserInteractionEnabled = false
        self.volumeTableView.isUserInteractionEnabled = false
    }
    
    func configStackView() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.timeTableView,
                               self.priceTableView,
                               self.volumeTableView]
        ).then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 1
        }
        
        self.scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
            make.height.equalTo(2400)
        }
    }
    
    func configTableView() {
        self.timeTableView.isScrollEnabled = false
        self.priceTableView.isScrollEnabled = false
        self.volumeTableView.isScrollEnabled = false
    }
}

extension CoinContractDetailsTabViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.timeTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContractTimeTableViewCell.className) else { return UITableViewCell()}
            return cell
        case self.priceTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContractPriceAndVolumeTableViewCell.className) else { return UITableViewCell()}
            return cell
        case self.volumeTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContractPriceAndVolumeTableViewCell.className) else { return UITableViewCell()}
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension CoinContractDetailsTabViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
