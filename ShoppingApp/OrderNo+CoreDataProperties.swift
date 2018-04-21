//
//  OrderNo+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//
//

import Foundation
import CoreData


extension OrderNo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderNo> {
        return NSFetchRequest<OrderNo>(entityName: "OrderNo")
    }

    @NSManaged public var orderNo: Int16

}
