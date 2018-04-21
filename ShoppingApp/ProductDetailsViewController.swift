//
//  ProductDetailsViewController.swift
//  ShoppingApp
//
//  Created by Mike Glover on 07/04/2018.
//  Copyright © 2018 Mike Glover. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController  {
    
    var product : Product
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var makerLabel: UILabel!
    
    @IBOutlet weak var quantityTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
