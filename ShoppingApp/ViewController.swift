//
//  ViewController.swift
//  ShoppingApp
//
//  Created by 117222405 on 05/04/2018.
//  Copyright © 2018 117222405. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    let categories = ["Books", "Movies", "TV Shows", "Music", "Electronics", "Sports"]
    let categoryImages : [UIImage] = [
        UIImage(named: "booksCategory")!,
        UIImage(named: "moviesCategory")!,
        UIImage(named: "tvShowsCategory")!,
        UIImage(named: "musicCategory")!,
        UIImage(named: "electronicsCategory")!,
        UIImage(named: "sportsCategory")!
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // UICollectionView setup
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // collectionView spacing
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8)
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 30) / 2, height: self.collectionView.frame.size.height / 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // build collectionView cells
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryImage.image = categoryImages[indexPath.item]
        cell.categoryLabel.text = categories[indexPath.item]
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toCategories"){
        
            let indexPath = self.collectionView.indexPath(for: sender as! CategoryCollectionViewCell)
            
            let destination = segue.destination as! CategoryProductsViewController
            
            destination.category = categories[(indexPath?.item)!]
        }
    }

}

