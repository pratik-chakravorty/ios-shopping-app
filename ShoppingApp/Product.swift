//
//  Product.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import Foundation

class Product {
    var product, maker, description, category, image : String
    var price : Double
    
    init(){
        self.product = ""
        self.maker = ""
        self.description = ""
        self.category = ""
        self.image = ""
        self.price = 0
    }
    
    init(product: String, maker: String, description: String, category: String, image: String, price: Double){
        self.product = product
        self.maker = maker
        self.description = description
        self.category = category
        self.image = image
        self.price = price
    }
    
}
