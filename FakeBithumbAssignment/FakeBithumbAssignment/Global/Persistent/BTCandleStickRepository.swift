//
//  BTCandleStickRepository.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/03.
//

import CoreData
import UIKit

struct BTCandleStickRepository {
    private let appDelegate: AppDelegate?
    private let privateMOC: NSManagedObjectContext?

    init() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        let context: NSManagedObjectContext? = appDelegate?.persistentContainer.viewContext
        self.appDelegate = appDelegate
        self.privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType).then {
            $0.parent = context
        }
    }
    
    func makeNewBTCandleStick() -> BTCandleStick? {
        guard let privateMOC = self.privateMOC else {
            return nil
        }
        return BTCandleStick(context: privateMOC)
    }
    
    func findAllBTCandleSticksOrderByDateAsc(
        orderCurrency: String,
        chartIntervals: BTCandleStickChartInterval
    ) -> [BTCandleStick] {
        guard let privateMOC = self.privateMOC else {
            return []
        }
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        let predicateOrderCurrency = NSPredicate(
            format: "orderCurrency == %@",
            NSString(string: orderCurrency)
        )
        let predicateChartIntervals = NSPredicate(
            format: "chartIntervals == %@",
            NSString(string: chartIntervals.rawValue)
        )
        let andPredicate = NSCompoundPredicate(
            type: .and,
            subpredicates: [predicateOrderCurrency, predicateChartIntervals]
        )
        let fetchRequest = BTCandleStick.fetchRequest()
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = andPredicate
        do {
            return try privateMOC.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func delete(of candleStick: BTCandleStick) {
        guard let privateMOC = self.privateMOC else {
            return
        }
        privateMOC.delete(candleStick)
    }
    
    func saveContext() {
        guard let appDelegate = self.appDelegate else {
            return
        }
        appDelegate.saveContext()
    }
}
