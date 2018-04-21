//
//  HistoryItem+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//
//

import Foundation
import CoreData


extension HistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
        return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    }

    @NSManaged public var image: String?
    @NSManaged public var maker: String?
    @NSManaged public var orderNo: Int16
    @NSManaged public var price: Double
    @NSManaged public var product: String?
    @NSManaged public var quantity: Int16

}
