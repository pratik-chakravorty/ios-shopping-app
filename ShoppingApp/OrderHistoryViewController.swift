//
//  OrderHistoryViewController.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit
import CoreData

class OrderHistoryViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cartAction(_ sender: UIBarButtonItem) {
        // programatically go to cart
        let storyboard: UIStoryboard = self.storyboard!
        let cartVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "cart")
        self.navigationController!.pushViewController(cartVC, animated: true)
    }
    @IBAction func homeAction(_ sender: UIBarButtonItem) {
        // programatically go to home screen
        let storyboard: UIStoryboard = self.storyboard!
        let homeVC: UIViewController = storyboard.instantiateViewController(withIdentifier: "home")
        self.navigationController!.pushViewController(homeVC, animated: true)
    }
    var historyItems = [[HistoryItem]()]
    var orderNos = [Int]()
    var orderTotals = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        updateTable()

        // Do any additional setup after loading the view.
    }
    
    func updateTable(){
        let fetchRequest: NSFetchRequest<HistoryItem> = HistoryItem.fetchRequest()
        
        // fetch core data
        do{
            // init order number, new history item array and order total variables
            let historyItemsFetch = try PersistenceService.context.fetch(fetchRequest)
            var curOrderNo = 1
            orderNos.append(curOrderNo)
            var index = 0
            var histArray = [[HistoryItem]()]
            var curOrderTotal: Double = 0
            orderTotals.append(curOrderTotal)
            for item in historyItemsFetch {
                if (item.orderNo > curOrderNo){
                    // if current item's order number is greater than previous order,
                    // create next item in totals array
                    curOrderTotal = 0
                    orderTotals.append(curOrderTotal)
                    
                    curOrderNo = Int(item.orderNo)
                    orderNos.append(curOrderNo)
                    
                    histArray.append([HistoryItem]())
                    
                    index += 1
                }
                
                // add item to history array and increase current order's total
                histArray[index].append(item)
                orderTotals[index] += item.price * Double(item.quantity)
            }
            // set main history item array to rebuilt array and reload table
            self.historyItems = histArray
            
            tableView.reloadData()
            
        }catch{
            print("Error retrieving history items")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderNos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // create order sections in tableview
        if (section < orderNos.count){
            return "Order #\(orderNos[section]), Total: €" + String(format: "%.2f", orderTotals[section])
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // add each order history item to correct section
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let item = historyItems[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = item.product
        cell.detailTextLabel?.text = "€" + String(format: "%.2f", item.price) + ", Quantity: " + String(item.quantity)
        
        return cell
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
