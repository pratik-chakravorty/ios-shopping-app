//
//  ShoppingCartViewController.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit
import CoreData

class ShoppingCartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var orderNoLabel: UILabel!
    
    @IBAction func homeAction(_ sender: UIBarButtonItem) {
        // programatically return to home screen
        let storyboard: UIStoryboard = self.storyboard!
        let homeVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "home")
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        // adds items to order history and remove from shopping cart
        let fetchRequest: NSFetchRequest<ShoppingCartItem> = ShoppingCartItem.fetchRequest()
        do{
            // fetch request
            let shoppingCartFetchItems = try PersistenceService.context.fetch(fetchRequest)
            
            if shoppingCartFetchItems.count > 0 {
                for item in shoppingCartFetchItems {
                    // if cart not empty, remove each item from shopping cart and add to order history
                    let historyItem = HistoryItem(context: PersistenceService.context)
                    historyItem.image = item.image
                    historyItem.maker = item.maker
                    historyItem.product = item.product
                    historyItem.price = item.price
                    historyItem.quantity = item.quantity
                    historyItem.orderNo = self.orderNo
                    
                    PersistenceService.context.delete(item)
                    
                    PersistenceService.saveContext()
                }
                // successful purchase alert
                let purchasedAlert = UIAlertController(title: "Items successfully purchased", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                purchasedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                    
                }))
                present(purchasedAlert, animated: true, completion: nil)
            }
            
        } catch {
            print("Error clearing shopping cart and adding item to history")
        }
        
        // update order number in core data
        let orderNoFetchRequest: NSFetchRequest<OrderNo> = OrderNo.fetchRequest()
        do {
            let fetchedOrderNo = try PersistenceService.context.fetch(orderNoFetchRequest)
            fetchedOrderNo.first!.orderNo += 1
            self.orderNo = fetchedOrderNo.first!.orderNo
            PersistenceService.saveContext()
        } catch {
            print("Error retrieving order no")
        }
        
        updateTable()
    }
    
    var orderNo: Int16 = 1
    
    var shoppingCartItems = [ShoppingCartItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        updateTable()
        
    }
    
    func updateTable(){
        // get current state of shopping cart in Core Data and reload tableview
        let orderNoFetchRequest: NSFetchRequest<OrderNo> = OrderNo.fetchRequest()
        do {
            let fetchedOrderNo = try PersistenceService.context.fetch(orderNoFetchRequest)
            if fetchedOrderNo.count == 0 {
                let orderNoInit = OrderNo(context: PersistenceService.context)
                orderNoInit.orderNo = self.orderNo
                PersistenceService.saveContext()
            } else {
                self.orderNo = fetchedOrderNo.first!.orderNo
            }
            orderNoLabel.text = "Order #\(self.orderNo)"
        } catch {
            print("Error retrieving order no")
        }
        
        let fetchRequest: NSFetchRequest<ShoppingCartItem> = ShoppingCartItem.fetchRequest()
        do{
            let shoppingCartFetchItems = try PersistenceService.context.fetch(fetchRequest)
            shoppingCartItems = shoppingCartFetchItems
            tableView.reloadData()
        } catch {
            print("Error retrieving shopping cart items")
        }
        
        var totalPrice: Double = 0
        if shoppingCartItems.count > 0 {
            for item in shoppingCartItems {
                totalPrice += (item.price * Double(item.quantity))
            }
        }
        totalLabel.text = "€" + String(format: "%.2f", totalPrice)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingCartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = shoppingCartItems[indexPath.row]
        
        cell.textLabel?.text = item.product
        cell.detailTextLabel?.text = "€" + String(format: "%.2f", item.price) + ", Quantity: " + String(item.quantity)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // tableview actions, visible by swiping left on tableview cell
        let editAction = UITableViewRowAction(style: .default, title: "Edit") { (action, index) in
            // UIAlert with new quantity textfield
            let editAlert = UIAlertController(title: "Edit quantity", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            editAlert.addTextField(configurationHandler: { (textfield) in
                textfield.text = String(describing: self.shoppingCartItems[indexPath.row].quantity)
                textfield.keyboardType = .numberPad
            })
            
            editAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                if let textfield = editAlert.textFields?.first{
                    let newQuantity = Int16(textfield.text!)
                    if newQuantity == nil{
                        // do nothing
                    } else if newQuantity! > 0 {
                        // update quantity in cart and reload table
                        self.shoppingCartItems[indexPath.row].quantity = newQuantity!
                        PersistenceService.saveContext()
                        
                        self.tableView.reloadData()
                        
                        var totalPrice: Double = 0
                        if self.shoppingCartItems.count > 0 {
                            for item in self.shoppingCartItems {
                                totalPrice += (item.price * Double(item.quantity))
                            }
                        }
                        self.totalLabel.text = "€" + String(format: "%.2f", totalPrice)
                        
                    } else {
                        // if quantity 0, remove from cart and update table
                        let item = self.shoppingCartItems[indexPath.row]
                        PersistenceService.context.delete(item)
                        PersistenceService.saveContext()
                        
                        self.shoppingCartItems.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .fade)
                        self.tableView.reloadData()
                        
                        var totalPrice: Double = 0
                        if self.shoppingCartItems.count > 0 {
                            for item in self.shoppingCartItems {
                                totalPrice += (item.price * Double(item.quantity))
                            }
                        }
                        self.totalLabel.text = "€" + String(format: "%.2f", totalPrice)
                    }
                }
                
            }))
            self.present(editAlert, animated: true, completion: nil)
            
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, index) in
            // remove item from cart and update table
            let item = self.shoppingCartItems[indexPath.row]
            PersistenceService.context.delete(item)
            PersistenceService.saveContext()
            
            self.shoppingCartItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            
            var totalPrice: Double = 0
            if self.shoppingCartItems.count > 0 {
                for item in self.shoppingCartItems {
                    totalPrice += (item.price * Double(item.quantity))
                }
            }
            self.totalLabel.text = "€" + String(format: "%.2f", totalPrice)
        }
        
        return [deleteAction, editAction]
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
