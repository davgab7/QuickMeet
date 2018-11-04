//
//  ContactDetailsVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/4/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit

class ContactDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedUser = User()
    
    var mediaItems = ["Phone","Email", "Facebook", "Snapchat", "Instagram"]
    var dataArray = ["","","","",""]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaCell
        cell.mediaNameLabel.text = dataArray[indexPath.row]
        cell.mediaImageView.image = UIImage(named: mediaItems[indexPath.row])
        if dataArray[indexPath.row] != "" {
            cell.mediaSwitch.isOn = true
        } else {
            cell.mediaSwitch.isOn = false
        }
        if dataArray[indexPath.row] == "" {
            if indexPath.row == 0 {
                cell.mediaNameLabel.text = "Phone"
            } else if indexPath.row == 1 {
                cell.mediaNameLabel.text = "Email"
            } else if indexPath.row == 2 {
                cell.mediaNameLabel.text = "Facebook"
            } else if indexPath.row == 3 {
                cell.mediaNameLabel.text = "Snapchat"
            } else if indexPath.row == 4 {
                cell.mediaNameLabel.text = "Instagram"
            }
        }
        cell.mediaSwitch.isHidden = true
        return cell
    }
    
    
    override func viewDidLoad() {
        setupUI()
    }
    
    func setupUI() {
        usernameLabel.text = self.selectedUser.username
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        print("this is the data array", dataArray)
    }
    
    
    
}
