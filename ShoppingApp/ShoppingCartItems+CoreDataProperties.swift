//
//  ShoppingCartItems+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by 117222405 on 07/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingCartItems {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCartItems> {
        return NSFetchRequest<ShoppingCartItems>(entityName: "ShoppingCartItems")
    }

    @NSManaged public var product: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16
    @NSManaged public var maker: String?

}
