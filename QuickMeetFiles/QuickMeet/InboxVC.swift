//
//  InboxVC.swift
//  QuickMeet
//
//  Created by Gabe Wilson on 11/4/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class InboxVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setupUI()
    }
    
    var contacts = [User]()
    var selectedUser = User()
    
    func queryData() {
        let query = PFQuery(className: "ContactInfo")
        query.whereKey("receiverID", equalTo: PFUser.current()?.objectId)
        query.findObjectsInBackground(block: { (objects, error) in
            if let error = error {
                print(error)
            } else if let objects = objects {
                if objects.isEmpty {
                    
                } else {
                    for object : PFObject in objects {
                        let user = User()
                        user.username = object["senderUsername"] as! String
                        if let phone = object["phone"] as? String {
                            user.phone = phone
                        } else {
                            user.phone = ""
                        }
                        if let email = object["email"] as? String {
                            user.email = email
                        }
                        if let facebook = object["facebook"] as? String {
                            user.facebook = facebook
                        } else {
                           user.facebook = ""
                        }
                        if let snapchat = object["snapchat"] as? String {
                            print("GOT THE SNAP!")
                            user.snapchat = snapchat
                        } else {
                           user.snapchat = ""
                        }
                        if let instagram = object["instagram"] as? String {
                            user.instagram = instagram
                        } else {
                            user.instagram = ""
                        }
                        
                        self.contacts.append(user)
                        self.tableView.reloadData()
                        if let image = object["profilePicture"] as? PFFile {
                            image.getDataInBackground {
                                (imageData:Data?, error:Error?) -> Void in
                                print(user.username)
                                user.image = UIImage(data: imageData!)
                                print("Got here")
                            }
                        }
                    }
                }
            }
            
        })
    }
    
    func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        queryData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showDetails", sender: nil)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as! tableViewCell
        self.selectedUser = contacts[indexPath.row]
        cell.personName.text = contacts[indexPath.row].username
        cell.personImage.image = contacts[indexPath.row].image
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let targetVC = segue.destination as! ContactDetailsVC
            targetVC.selectedUser = self.selectedUser
            targetVC.dataArray  = [selectedUser.phone, selectedUser.email, selectedUser.facebook, selectedUser.snapchat, selectedUser.instagram]
            print("this is the user snap", selectedUser.snapchat)
        }
    }
    
    
}
