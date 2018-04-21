//
//  DetailsViewController.swift
//  ShoppingApp
//
// Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController {
    
    var product: Product = Product()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var makerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    
    @IBOutlet weak var quantityTF: UITextField!
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        // get quantity
        let quantity = Int16(quantityTF.text!)
        
        if quantity != nil{
            // if quantity valid, check to see if item already in shopping cart. if present, update quantity.
            // else, create new shopping cart item
            let fetchRequest: NSFetchRequest<ShoppingCartItem> = ShoppingCartItem.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "product == %@", product.product)
            
            do{
                let shoppingCartFetchItems = try PersistenceService.context.fetch(fetchRequest)
                
                if shoppingCartFetchItems.count > 0 {
                    // update quantity
                    shoppingCartFetchItems.first?.quantity += quantity!
                } else {
                    // create new shopping cart item
                    let item = ShoppingCartItem(context: PersistenceService.context)
                    item.product = product.product
                    item.price = product.price
                    item.maker = product.maker
                    item.image = product.image
                    item.quantity = quantity!
                }
                
                PersistenceService.saveContext()
            } catch {}
            
            // added to cart message
            let addedAlert = UIAlertController(title: "Added to cart", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            addedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                
            }))
            present(addedAlert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: product.image)
        productLabel.text = product.product
        makerLabel.text = product.maker
        priceLabel.text = "€" + String(format: "%.2f", product.price)
        descriptionTV.text = product.description

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
