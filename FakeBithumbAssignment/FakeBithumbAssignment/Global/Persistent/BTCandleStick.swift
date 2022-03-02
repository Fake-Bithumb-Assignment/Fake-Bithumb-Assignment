//
//  CandleStick.swift
//  FakeBithumbAssignment
//
//  Created by momo on 2022/03/03.
//

import CoreData

public class BTCandleStick: NSManagedObject {
    @NSManaged public var orderPayment: String
    @NSManaged public var chartIntervals: String
    @NSManaged public var date: Int
    @NSManaged public var openingPrice: Double
    @NSManaged public var highPrice: Double
    @NSManaged public var lowPrice: Double
    @NSManaged public var tradePrice: Double
    @NSManaged public var tradeVolume: Double
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BTCandleStick> {
        return NSFetchRequest<BTCandleStick>(entityName: "BTCandleStick")
    }
}
