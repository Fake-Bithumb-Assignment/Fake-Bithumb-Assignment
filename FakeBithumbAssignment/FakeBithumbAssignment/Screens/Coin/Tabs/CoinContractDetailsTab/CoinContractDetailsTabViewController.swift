//
//  CoinContractDetailsTabViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

enum ContractHeader {
    case time, price, volume
}

final class CoinContractDetailsTabViewController: BaseViewController {
    
    // MARK: - Instance Property
    
    let transactionAPIService: TransactionAPIService = TransactionAPIService(apiService: HttpService(),
                                                                             environment: .development)
    var btsocketAPIService: BTSocketAPIService = BTSocketAPIService()
    
    var transactionData: [TransactionAPIResponse] = []
        
    private let timeTableView = UITableView().then {
        $0.register(ContractTimeTableViewCell.self,
                    forCellReuseIdentifier: ContractTimeTableViewCell.className)
        $0.register(ContractTableHeaderViewCell.self, forHeaderFooterViewReuseIdentifier: ContractTableHeaderViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let priceTableView = UITableView().then {
        $0.register(ContractPriceAndVolumeTableViewCell.self,
                    forCellReuseIdentifier: ContractPriceAndVolumeTableViewCell.className)
        $0.register(ContractTableHeaderViewCell.self,
                    forHeaderFooterViewReuseIdentifier: ContractTableHeaderViewCell.className)
        $0.backgroundColor = .clear
    }
    
    private let volumeTableView = UITableView().then {
        $0.register(ContractPriceAndVolumeTableViewCell.self,
                    forCellReuseIdentifier: ContractPriceAndVolumeTableViewCell.className)
        $0.register(ContractTableHeaderViewCell.self,
                    forHeaderFooterViewReuseIdentifier: ContractTableHeaderViewCell.className)
        $0.backgroundColor = .clear
    }
    
    let scrollView = UIScrollView().then { make in
        make.backgroundColor = .white
    }
    
    
    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.getTransactionData(orderCurrency: "BTC", paymentCurrency: "KRW")
        self.getWebsocketTransactionData(orderCurrency: "BTC")
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
        
        timeTableView.snp.makeConstraints { make in
            make.width.equalTo(stackView).multipliedBy(0.2)
        }
        
        priceTableView.snp.makeConstraints { make in
            make.width.equalTo(stackView).multipliedBy(0.4)
        }
        
        volumeTableView.snp.makeConstraints { make in
            make.width.equalTo(stackView).multipliedBy(0.395)
        }
        
        stackView.backgroundColor = .systemGray5
    }
    
    func configTableView() {
        self.timeTableView.isScrollEnabled = false
        self.priceTableView.isScrollEnabled = false
        self.volumeTableView.isScrollEnabled = false
        
        self.timeTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.priceTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.volumeTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func getTransactionData(orderCurrency: String, paymentCurrency: String) {
        Task {
            do {
                let transactionData = try await transactionAPIService.getTransactionData(orderCurrency: orderCurrency,
                                                                                         paymentCurrency: paymentCurrency)
                
                if let transactionData = transactionData {
                    self.transactionData = transactionData.reversed()
                } else {
                    // TODO: 에러 처리 얼럿 띄우기
                }
                self.reloadTableViews()
            } catch HttpServiceError.serverError {
                print("serverError")
            } catch HttpServiceError.clientError(let message) {
                print("clientError:\(message)")
            }
        }
    }
    
    private func getWebsocketTransactionData(orderCurrency: String) {
        btsocketAPIService.subscribeTransaction(
            orderCurrency: [Coin.BTC],
            paymentCurrency: .krw
        ) { response in
            self.updateTransactionData(coin: Coin.BTC, data: response)
        }
    }
    
    private func updateTransactionData(coin: Coin,
                                       data: BTSocketAPIResponse.TransactionResponse) {
        for transaction in data.content.list {
            let transactionResponse = TransactionAPIResponse(transactionDate: "\(transaction.contDtm)",
                                                             unitsTraded: "\(transaction.contQty)",
                                                             price: "\(transaction.contPrice)",
                                                             upDn: "\(transaction.updn)")
            self.transactionData.insert(transactionResponse, at: 0)
            self.transactionData.popLast()
        }
        self.reloadTableViews()
    }
    
    private func reloadTableViews() {
        self.timeTableView.reloadData()
        self.priceTableView.reloadData()
        self.volumeTableView.reloadData()
    }
}

extension CoinContractDetailsTabViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ContractTableHeaderViewCell.className) as? ContractTableHeaderViewCell else { return UITableViewCell() }
        switch tableView {
        case self.timeTableView:
            header.setHeaderViewTitle(to: ContractHeader.time)
        case self.priceTableView:
            header.setHeaderViewTitle(to: ContractHeader.price)
        case self.volumeTableView:
            header.setHeaderViewTitle(to: ContractHeader.volume)
        default:
            return UITableViewCell()
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case self.timeTableView:
            let cell = tableView.dequeueReusableCell(withType: ContractTimeTableViewCell.self, for: indexPath)
            if self.transactionData.count != 0 {
                cell.update(to: self.transactionData[indexPath.row])
            }
            return cell
        case self.priceTableView:
            let cell = tableView.dequeueReusableCell(withType: ContractPriceAndVolumeTableViewCell.self, for: indexPath)
            if self.transactionData.count != 0 {
                cell.update(to: self.transactionData[indexPath.row], type: .price)
            }
            return cell
        case self.volumeTableView:
            let cell = tableView.dequeueReusableCell(withType: ContractPriceAndVolumeTableViewCell.self, for: indexPath)
            if self.transactionData.count != 0 {
                cell.update(to: self.transactionData[indexPath.row], type: .volume)
            }
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
