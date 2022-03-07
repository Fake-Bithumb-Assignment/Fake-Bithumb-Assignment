//
//  CoinContractDetailsTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

class CoinContractDetailsTabViewController: UIViewController {
    
    // MARK: - Instance Property
    private let tiemeTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let priceTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let volumeTableView = UITableView().then {
        $0.register(CoinTableViewCell.self, forCellReuseIdentifier: CoinTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
