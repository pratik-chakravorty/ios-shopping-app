//
//  ShoppingCartItem+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//
//

import Foundation
import CoreData


extension ShoppingCartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCartItem> {
        return NSFetchRequest<ShoppingCartItem>(entityName: "ShoppingCartItem")
    }

    @NSManaged public var maker: String?
    @NSManaged public var price: Double
    @NSManaged public var product: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var image: String?

}
