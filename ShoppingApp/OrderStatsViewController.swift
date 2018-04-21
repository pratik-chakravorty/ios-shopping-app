//
//  OrderStatsViewController.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit
import CoreData

class OrderStatsViewController: UIViewController {

    @IBOutlet weak var numOrdersLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalSpendingLabel: UILabel!
    @IBOutlet weak var highestQuantityProductLabel: UILabel!
    @IBOutlet weak var highestQuantityNumLabel: UILabel!
    @IBOutlet weak var mostExpensiveProductLabel: UILabel!
    @IBOutlet weak var mostExpensivePriceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest : NSFetchRequest<HistoryItem> = HistoryItem.fetchRequest()
        
        //find num orders
        var predicate = NSPredicate(format: "orderNo == max(orderNo)")
        fetchRequest.predicate = predicate
        do {
            let numOrderResults : [HistoryItem] = try PersistenceService.context.fetch(fetchRequest)
            if numOrderResults.count > 0{
                numOrdersLabel.text = "\(numOrderResults.first!.orderNo)"
            } else {
                numOrdersLabel.text = "0"
            }
        } catch {print("Error: Can't complete fetch request")}
        
        // find total items bought and total spending. Uses NSExpressionDescriptions
        let totalFetch: NSFetchRequest<NSFetchRequestResult> = HistoryItem.fetchRequest()
        let totalExpressionDesc = NSExpressionDescription()
        totalExpressionDesc.name = "totalItems"
        totalExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "quantity")])
        totalExpressionDesc.expressionResultType = .integer16AttributeType
        
        let spendingExpressionDesc = NSExpressionDescription()
        spendingExpressionDesc.name = "totalItemCost"
        spendingExpressionDesc.expression = NSExpression(forFunction: "multiply:by:", arguments: [NSExpression(forKeyPath: "price"), NSExpression(forKeyPath: "quantity")])
        spendingExpressionDesc.expressionResultType = .doubleAttributeType
        
        totalFetch.resultType = .dictionaryResultType
        totalFetch.propertiesToFetch = [totalExpressionDesc, spendingExpressionDesc]
        do {
            let totalResults = try PersistenceService.context.fetch(totalFetch) as! [NSDictionary]
            if totalResults.count > 0 {
                let returnedDict = totalResults.first!
                let totalItems = returnedDict["totalItems"]!
                totalItemsLabel.text = "\(totalItems)"
                
                var totalSpending: Double = 0
                for item in totalResults{
                    totalSpending += item["totalItemCost"] as! Double
                }
                totalSpendingLabel.text = "€" + String(format: "%.2f", totalSpending)
            }
        } catch {
            
        }
        
        
        //find max quantity item
        predicate = NSPredicate(format: "quantity == max(quantity)")
        fetchRequest.predicate = predicate
        do {
            let maxQuantityFetchResult : [HistoryItem] = try PersistenceService.context.fetch(fetchRequest)
            if maxQuantityFetchResult.count > 0{
                highestQuantityProductLabel.text = maxQuantityFetchResult.first?.product
                highestQuantityNumLabel.text = String(describing: maxQuantityFetchResult.first!.quantity)
            } else {
                highestQuantityProductLabel.text = ""
                highestQuantityNumLabel.text = "0"
            }
        } catch {print("Error: Can't complete fetch request")}
        
        //find max price item
        predicate = NSPredicate(format: "price == max(price)")
        fetchRequest.predicate = predicate
        do {
            let maxPriceResult: [HistoryItem] = try PersistenceService.context.fetch(fetchRequest)
            if maxPriceResult.count > 0 {
                mostExpensiveProductLabel.text = maxPriceResult.first?.product
                mostExpensivePriceLabel.text = "€" + String(format: "%.2f", maxPriceResult.first!.price)
            } else {
                mostExpensiveProductLabel.text = ""
                mostExpensivePriceLabel.text = "€" + String(format: "%.2f", 0)
            }
        } catch {print("Error: Can't complete fetch request")}

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
