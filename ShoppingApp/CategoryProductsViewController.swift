//
//  CategoryProductsViewController.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit
import SQLite3

class CategoryProductsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category = ""
    var products = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 30) / 2, height: self.collectionView.frame.size.height / 2.5)
        
        // SQLite db url
        let fileURL = Bundle.main.url(forResource: "shoppingAppDB", withExtension: "sqlite")!
        
        // open database
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        
        // create query and prepare result table
        var statement: OpaquePointer?
        
        let query = "SELECT * FROM products WHERE category = '" + category + "'"
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
        }
        
        // extract information from each row
        while sqlite3_step(statement) == SQLITE_ROW {
            var product, maker, description, category, image : String
            var price : Double
            
            if let cProductStr = sqlite3_column_text(statement, 2){
                product = String(cString: cProductStr)
            } else {
                product = ""
            }
            
            if let cMakerStr = sqlite3_column_text(statement, 3){
                maker = String(cString: cMakerStr)
            } else {
                maker = ""
            }
            
            if let cDescriptionStr = sqlite3_column_text(statement, 5){
                description = String(cString: cDescriptionStr)
            } else {
                description = ""
            }
            
            if let cCatStr = sqlite3_column_text(statement, 1){
                category = String(cString: cCatStr)
            } else {
                category = ""
            }
            
            if let cImageStr = sqlite3_column_text(statement, 6){
                image = String(cString: cImageStr)
            } else {
                image = ""
            }
            
            if let cPriceDec = sqlite3_column_text(statement, 4){
                price = Double(String(cString: cPriceDec))!
            } else {
                price = 0
            }
            
            let item = Product(product: product, maker: maker, description: description, category: category, image: image, price: price)
            products.append(item)
        }
        
        // finalize query
        if sqlite3_finalize(statement) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error finalizing prepared statement: \(errmsg)")
        }
        
        // close db
        if sqlite3_close(db) != SQLITE_OK {
            print("error closing database")
        }
        
        db = nil
        
        // update table with new data
        collectionView.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // create collectionView cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        let image = UIImage(named: products[indexPath.item].image)
        
        cell.imageView.image = image
        cell.productLabel.text = products[indexPath.item].product
        cell.makerLabel.text = products[indexPath.item].maker
        cell.priceLabel.text = "€" + String(format: "%.2f", products[indexPath.item].price)
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toDetails"){
            let indexPath = self.collectionView.indexPath(for: sender as! ProductCollectionViewCell)
            
            let destination = segue.destination as! DetailsViewController
            
            destination.product = products[(indexPath?.item)!]
        }
    }
    

}
