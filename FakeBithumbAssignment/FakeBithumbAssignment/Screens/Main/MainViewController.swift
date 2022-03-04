//
//  MainViewController.swift
//  FakeBithumbAssignment
//
//  Created by 박예빈 on 2022/02/23.
//

import UIKit

import SnapKit
import Then

final class MainViewController: BaseViewController {

    // MARK: - Instance Property

    private let headerView = HeaderView()

    private var totalCoinList: [CoinData] = []

    private var interestedCoinList: [CoinData] = []

    private let totalCoinListView = TotalCoinListView()

    private let interestedCoinListView = InterestedCoinListView()

    // MARK: - Life Cycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCoinData()
        configureUI()
        setUpViews()
    }

    // MARK: - custom func

    private func configureUI() {
        let stackView = UIStackView(arrangedSubviews: [
            self.headerView, self.totalCoinListView, self.interestedCoinListView
        ]).then {
            $0.axis = .vertical
            $0.alignment = .fill
        }

        self.totalCoinListView.totalCoinList = totalCoinList
        self.view.addSubview(stackView)
        self.headerView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(200)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func configureCoinData() {
        Coin.allCases.forEach {
            if UserDefaults.standard.string(forKey: $0.rawValue) != nil {
                totalCoinList.append(
                    CoinData(
                        coinName: $0.rawValue,
                        currentPrice: "43,926,000",
                        fluctuationRate: "-23.46%",
                        tradeValue: "256,880백만",
                        isInterested: true
                    ))
            }
            else {
                totalCoinList.append(
                    CoinData(
                        coinName: $0.rawValue,
                        currentPrice: "43,926,000",
                        fluctuationRate: "-23.46%",
                        tradeValue: "256,880백만"
                    ))
            }
        }
        
        self.interestedCoinList = totalCoinList.filter { $0.isInterested }
        interestedCoinListView.interestedCoinList = self.interestedCoinList
    }

    private func setUpViews() {
        headerView.delegate = self
        totalCoinListView.delegate = self
        interestedCoinListView.delegate = self
    }

    private func setUserDefaults(_ coinName: String) {
        if let alreadyInterestedCoin = UserDefaults.standard.string(forKey: coinName) {
            UserDefaults.standard.removeObject(forKey: alreadyInterestedCoin)
        }
        else {
            UserDefaults.standard.set(coinName, forKey: coinName)
        }
    }
}

// MARK: - HeaderViewDelegate

extension MainViewController: HeaderViewDelegate {
    func selectCategory(_ category: Category) {
        switch category {
        case .krw:
            self.totalCoinListView.isHidden = false
            self.interestedCoinListView.isHidden = true
        case .interest:
            self.totalCoinListView.isHidden = true
            self.interestedCoinListView.isHidden = false
        default:
            break
        }
    }
}

// MARK: - CoinDelgate

extension MainViewController: CoinDelgate {
    func updateInterestList(coin: CoinData) {
        let coinName = coin.coinName
        coin.isInterested.toggle()
        self.interestedCoinList = self.totalCoinList.filter { $0.isInterested }
        interestedCoinListView.interestedCoinList = self.interestedCoinList
        setUserDefaults(coinName)
    }
    
    func showCoinInformation(coin: CoinData) {
        let vc = CoinViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
