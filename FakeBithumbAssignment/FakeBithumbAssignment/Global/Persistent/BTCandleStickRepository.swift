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
    private let context: NSManagedObjectContext?
    
    init() {
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        self.appDelegate = appDelegate
        self.context = appDelegate?.persistentContainer.viewContext
    }
    
    func makeNewBTCandleStick() -> BTCandleStick? {
        guard let context = self.context else {
            return nil
        }
        return BTCandleStick(context: context)
    }
    
    func findAllBTCandleSticksOrderByDateDesc(
        orderCurrency: String,
        chartIntervals: BTCandleStickChartInterval
    ) -> [BTCandleStick] {
        guard let context = self.context else {
            return []
        }
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
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
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func delete(of candleStick: BTCandleStick) {
        guard let context = self.context else {
            return
        }
        context.delete(candleStick)
    }
    
    func saveContext() {
        guard let appDelegate = self.appDelegate else {
            return
        }
        appDelegate.saveContext()
    }
}
