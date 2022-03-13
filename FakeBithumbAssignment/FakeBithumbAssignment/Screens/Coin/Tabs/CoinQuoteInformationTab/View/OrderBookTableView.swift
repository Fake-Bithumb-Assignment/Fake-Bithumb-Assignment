//
//  OrderBookTableView.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/09.
//

import UIKit

final class OrderBookTableView: UITableView {
    
    // MARK: - Instance Property
    private lazy var quoteDatasource: UITableViewDiffableDataSource<OrderType, Quote> = configureDataSource()
    var type: OrderType = .ask {
        didSet {
            self.configUI()
        }
    }
    private var quotes: [Quote] = []
    private let cellCount: Int = 30
    private var maxQuantity: Double = 100.0
    private var color: UIColor {
        get {
            switch self.type {
            case .ask:
                return UIColor(named: "sellView") ?? UIColor.blue
            case .bid:
                return UIColor(named: "buyView") ?? UIColor.red
            }
        }
    }
    
    // MARK: - Initializer
        
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.configUI()
        self.configTableView()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configUI()
        self.configTableView()
    }
    
    // MARK: - Custom func
    
    private func configUI() {
        self.separatorStyle = .none
        self.rowHeight = 35
    }
    
    private func configTableView() {
        self.register(cell: OrderBookTableViewCell.self)
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = false
    }
    
    private func configureDataSource() -> UITableViewDiffableDataSource<OrderType, Quote> {
        let dataSource = UITableViewDiffableDataSource<OrderType, Quote>(
            tableView: self
        ) {  tableView, indexPath, quote in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: OrderBookTableViewCell.className,
                for: indexPath
            ) as? OrderBookTableViewCell
            cell?.update(type: self.type, quote: quote, maxQuantity: self.maxQuantity)
            return cell
        }
        var snapshot = NSDiffableDataSourceSnapshot<OrderType, Quote>()
        snapshot.appendSections([self.type])
        snapshot.appendItems(quotes, toSection: self.type)
        dataSource.apply(snapshot, animatingDifferences: false)
        return dataSource
    }
    
    private func resetData() {
        self.quotes.removeAll()
        var currentSnapshot = self.quoteDatasource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([self.type])
        self.quoteDatasource.apply(currentSnapshot, animatingDifferences: false)
        self.quotes = []
    }
    
    func updatedQuotes(to quotes: [Quote]) {
        let sortedQuotes: [Quote] = self.type == .ask ?
        self.getSortedSellQuotes(of: quotes) : self.getSortedBuyQuotes(of: quotes)
        var currentSnapshot = self.quoteDatasource.snapshot()
        currentSnapshot.deleteAllItems()
        currentSnapshot.appendSections([self.type])
        currentSnapshot.appendItems(sortedQuotes, toSection: self.type)
        self.maxQuantity = sortedQuotes.max { $0.quantityNumber < $1.quantityNumber }?.quantityNumber ?? 100.0
        self.quoteDatasource.apply(currentSnapshot, animatingDifferences: false)
        self.quotes = sortedQuotes
    }
    
    private func getSortedSellQuotes(of quotes: [Quote]) -> [Quote] {
        guard !quotes.isEmpty else {
            return []
        }
        guard quotes.count >= 30 else {
            return Quote.getEmptyQuoteList(number: 30 - quotes.count) +
            Array(quotes.sorted(by: Quote.asc)).reversed()
        }
        return Array(quotes.sorted(by: Quote.asc)[..<30]).reversed()
    }
    
    private func getSortedBuyQuotes(of quotes: [Quote]) -> [Quote] {
        guard !quotes.isEmpty else {
            return []
        }
        guard quotes.count >= 30 else {
            return Array(quotes.sorted(by: Quote.desc)) +
            Quote.getEmptyQuoteList(number: 30 - quotes.count)
        }
        return Array(quotes.sorted(by: Quote.desc)[..<30])
    }
}
