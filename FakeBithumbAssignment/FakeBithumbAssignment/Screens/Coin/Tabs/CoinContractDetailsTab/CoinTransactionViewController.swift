//
//  CoinTransactionViewController.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/13.
//

import UIKit

import SnapKit
import Then

final class CoinTransactionViewController: BaseViewController, CoinAcceptable {
    
    // MARK: - Instance Property
    
    private var orderCurreny: Coin = .BTC
    private let transactionAPIService: TransactionAPIService = TransactionAPIService()
    private var btsocketAPIService: SocketAPIService = SocketAPIService()
    private var sortedTransaction: [Transaction] = []
    private var totalTransactions: Set<Transaction> = Set() {
        didSet {
            self.updateDataSource()
        }
    }
    private lazy var headerView: UIStackView = self.configHeaderView()
    private let tableView: UITableView = UITableView().then {
        $0.register(
            cell: TransactionTableViewCell.self,
            forCellReuseIdentifier: TransactionTableViewCell.className
        )
        $0.rowHeight = 30
        $0.separatorStyle = .none
    }
    private lazy var dataSource: UITableViewDiffableDataSource<TransactionSection, Transaction> =
    self.configDataSource()
    
    // MARK: - Life Cycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setHeaderViewOrderCurrency()
        self.sortedTransaction = []
        self.totalTransactions = Set()
        self.fetchFromAPI()
        self.fetchFromSocket()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        btsocketAPIService.disconnectAll()
        super.viewDidDisappear(animated)
    }
        
    // MARK: - custom funcs
    
    func accept(of coin: Coin) {
        self.orderCurreny = coin
    }
    
    override func configUI() {
        let stackView: UIStackView = UIStackView(
            arrangedSubviews: [self.headerView, self.tableView]
        ).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }
        self.headerView.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func fetchFromAPI() {
        Task {
            guard let response: [TransactionAPIResponse] = await
                    self.transactionAPIService.requestTransactionHistory(
                        of: self.orderCurreny
                    ) else {
                        return
                    }
            response.forEach { transactionResponse in
                let transaction: Transaction = Transaction(
                    date: transactionResponse.transactionDate,
                    price: transactionResponse.price,
                    quantity: transactionResponse.unitsTraded,
                    transactionType: Transaction.TransactionType(type: transactionResponse.type)
                )
                self.totalTransactions.insert(transaction)
            }
        }
    }
    
    private func fetchFromSocket() {
        self.btsocketAPIService.subscribeTransaction(
            orderCurrency: [self.orderCurreny],
            paymentCurrency: .krw
        ) { response in
            response.content.list.forEach { transactionResponse in
                guard let date: Substring =
                        transactionResponse.contDtmString.split(separator: ".").first
                else {
                    return
                }
                let transaction: Transaction = Transaction(
                    date: String(date),
                    price: transactionResponse.contPriceString,
                    quantity: transactionResponse.contQtyString,
                    transactionType: Transaction.TransactionType(buyCell: transactionResponse.buySellGb)
                )
                self.totalTransactions.insert(transaction)
            }
        }
    }

    private func configDataSource() -> UITableViewDiffableDataSource<TransactionSection, Transaction> {
        let dataSource = UITableViewDiffableDataSource<TransactionSection, Transaction>(
            tableView: self.tableView
        ) {  tableView, indexPath, transaction in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TransactionTableViewCell.className,
                for: indexPath
            ) as? TransactionTableViewCell
            cell?.transaction = transaction
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<TransactionSection, Transaction>()
        snapshot.appendSections([.main])
        snapshot.appendItems(self.sortedTransaction, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func updateDataSource() {
        self.sortedTransaction = self.totalTransactions.sorted { $0.date > $1.date }
        var currentSnapshot = self.dataSource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(self.sortedTransaction, toSection: .main)
        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    private func configHeaderView() -> UIStackView {
        let dateLabel: UILabel = UILabel().then {
            $0.textAlignment = .center
            $0.text = "시간"
            $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
        let priceLabel: UILabel = UILabel().then {
            $0.textAlignment = .center
            $0.text = "가격(KRW)"
            $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
        let quantityLabel: UILabel = UILabel().then {
            $0.textAlignment = .center
            $0.text = "체결량(\(String(describing: self.orderCurreny)))"
            $0.font = UIFont.preferredFont(forTextStyle: .subheadline)
        }
        let stackview: UIStackView = UIStackView(
            arrangedSubviews: [dateLabel, priceLabel, quantityLabel]
        ).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.backgroundColor = .systemGray5
        }
        stackview.snp.makeConstraints { make in
            make.width.equalTo(dateLabel).multipliedBy(5)
            make.width.equalTo(priceLabel).multipliedBy(2.5)
            make.width.equalTo(quantityLabel).multipliedBy(2.5)
        }
        return stackview
    }
    
    private func setHeaderViewOrderCurrency() {
        guard let lastHeaderStackSubview: UIView = self.headerView.arrangedSubviews.last,
              let quantityLabel: UILabel = lastHeaderStackSubview as? UILabel
        else {
            return
        }
        quantityLabel.text = "체결량(\(String(describing: self.orderCurreny)))"
    }
}

extension CoinTransactionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        self.view.endEditing(true)
        return nil
    }
}

struct Transaction: Hashable {
    
    // MARK: - Instance Property

    let date: String
    let price: String
    let quantity: String
    let transactionType: TransactionType
    
    enum TransactionType {
        case ask, bid
        
        // MARK: - Initializer
        
        init(buyCell: SocketAPIResponse.TransactionResponse.Content.Transaction.BuyCell) {
            switch buyCell {
            case .sell:
                self = .ask
            case .buy:
                self = .bid
            }
        }
        
        init(type: String?) {
            switch type {
            case "bid":
                self = .bid
            default:
                self = .ask
            }
        }
    }
}

enum TransactionSection {
    case main
}
