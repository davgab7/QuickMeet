//
//  sendInfoVC.swift
//  QuickMeet
//
//  Created by Tyler Chan on 11/4/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class sendInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBAction func sendAction(_ sender: Any) {
        
        let ContactInfo = PFObject(className: "ContactInfo")
        ContactInfo["receiver"] = selectedUser.username
        ContactInfo["sender"] = PFUser.current()?.username
        ContactInfo["phone"] = dataArray[0]
        ContactInfo["email"] = dataArray[1]
        ContactInfo["facebook"] = dataArray[2]
        ContactInfo["snapchat"] = dataArray[3]
        ContactInfo["instagram"] = dataArray[4]
        ContactInfo.saveInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "sendUnwind", sender: nil)
            }
        }
        
    }
    
    
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var mediaItems = ["Phone","Email", "Facebook", "Snapchat", "Instagram"]
    var selectedUser = User()
    var dataArray = ["","","","",""]
    var chosenMediaItems = [String]()
    
    override func viewDidLoad() {
        setupUI()
        queryUserData()
        tableView.tableFooterView = UIView()
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func queryUserData() {
        let query = PFQuery(className: "_User")
        query.getObjectInBackground(withId: (PFUser.current()?.objectId)!) { (object, error) in
            let user = object as! PFUser
            if let phone = user["phone"] as? String {
                self.dataArray[0] = phone
            } else {
                self.dataArray[0] = ""
            }
            if let email = user["email"] as? String {
                self.dataArray[1] = email
            } else {
                self.dataArray[1] = ""
            }
            if let facebook = user["facebook"] as? String {
                self.dataArray[2] = facebook
            } else {
                self.dataArray[2] = ""
            }
            if let snapchat = user["snapchat"] as? String {
                self.dataArray[3] = snapchat
            } else {
                self.dataArray[3] = ""
            }
            if let instagram = user["instagram"] as? String {
                self.dataArray[4] = instagram
            } else {
                self.dataArray[4] = ""
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func onSwitchValueChanged(_ mediaSwitch: UISwitch) {
        if mediaSwitch.isOn {
            print("on")
        } else {
            print("off")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChooseMediaCell
        cell.mediaNameLabel.text = dataArray[indexPath.row]
        cell.mediaImageView.image = UIImage(named: mediaItems[indexPath.row])
        cell.mediaSwitch.isOn = false
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
        cell.mediaSwitch.tag = indexPath.row
        cell.mediaSwitch.addTarget(self, action: #selector(sendInfoVC.onSwitchValueChanged), for: .touchUpInside)
        return cell
    }
    
}

