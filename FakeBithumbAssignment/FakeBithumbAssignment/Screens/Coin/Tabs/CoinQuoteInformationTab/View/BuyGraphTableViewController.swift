//
//  BuyView.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/03/02.
//

import UIKit

import SnapKit
import Then

final class BuyGraphTableViewController: UITableViewController {
    
    // MARK: - Instance Property
    
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        self.configUI()
        self.setTableView()
        self.setDelegates()
    }
    
    func configUI() {
        self.view.backgroundColor = UIColor(named: "buyView")
        self.tableView.separatorStyle = .none
    }
    
    func setTableView() {
        self.tableView.register(cell: BuyGraphTableViewCell.self)
        self.tableView.isScrollEnabled = false
        self.tableView.isUserInteractionEnabled = false
    }
    
    func setDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension BuyGraphTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withType: BuyGraphTableViewCell.self, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
}
