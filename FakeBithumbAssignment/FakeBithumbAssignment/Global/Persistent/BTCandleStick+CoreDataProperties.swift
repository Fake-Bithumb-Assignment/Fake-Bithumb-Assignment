//
//  BTCandleStick+CoreDataProperties.swift
//  
//
//  Created by momo on 2022/03/04.
//
//

import Foundation
import CoreData


extension BTCandleStick {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTCandleStick> {
        return NSFetchRequest<BTCandleStick>(entityName: "BTCandleStick")
    }

    @NSManaged public var chartIntervals: String?
    @NSManaged public var date: Int64
    @NSManaged public var highPrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var openingPrice: Double
    @NSManaged public var orderCurrency: String?
    @NSManaged public var tradePrice: Double
    @NSManaged public var tradeVolume: Double

}
