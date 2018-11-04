//
//  EnterInfoVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/3/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit

class EnterInfoVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var chosenItems = [String]()
    
    override func viewDidLoad() {
        print("made it to view did load")
        collectionView?.isPagingEnabled = true
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        collectionView?.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chosenItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! EnterInfoCollectionViewCell
        cell.imageView.layer.cornerRadius = cell.imageView.frame.height/2
        cell.imageView.layer.masksToBounds = true
        cell.imageView.backgroundColor = self.navigationController?.navigationBar.barTintColor
        cell.imageView.layer.borderWidth = 3.0
        cell.imageView.layer.borderColor = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0).cgColor
        cell.titleLabel.text = chosenItems[indexPath.item]
        cell.contentView.layer.cornerRadius = 30.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        let cellMaxY = cell.frame.maxY
        let viewMaxY = collectionView.frame.maxY
        cell.frame.origin.y = cell.frame.origin.y + (viewMaxY - cellMaxY)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let navBarHeight = navigationController!.navigationBar.frame.height
        return CGSize(width: view.frame.width, height: view.frame.height - navBarHeight)
    }
}
